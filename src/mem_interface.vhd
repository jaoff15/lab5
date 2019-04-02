
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity mem_interface is
    Port ( clk          : in  std_logic                     := '0';
           start        : in  std_logic                     := '0';
           row          : in  integer range 0 to 7;
           done         : out std_logic                     := '0';
           red          : out std_logic_vector(63 downto 0) := (others => '0'); 
           green        : out std_logic_vector(63 downto 0) := (others => '0');
           blue         : out std_logic_vector(63 downto 0) := (others => '0')
    );
end mem_interface;

architecture Behavioral of mem_interface is
    
    component LED_RAM_wrapper is
      port (
            BRAM_PORTB_0_addr   : in  std_logic_vector ( 31 downto 0 )  := (others => '0');
            BRAM_PORTB_0_clk    : in  std_logic                         := '0';
            BRAM_PORTB_0_dout   : out std_logic_vector ( 31 downto 0 )  := (others => '0');
            BRAM_PORTB_0_en     : in  std_logic                         := '0'
      );
    end component;
    
    
    -- Memory interface states
    type state_type is (STATE_RESET, STATE_SETUP, STATE_LATCH, STATE_READY);
    signal state : state_type := STATE_READY;
    
    
    -- Temporary signals for colors
    signal values_red           : std_logic_vector(63 downto 0) := (others => '0');
    signal values_green         : std_logic_vector(63 downto 0) := (others => '0');
    signal values_blue          : std_logic_vector(63 downto 0) := (others => '0');
    

    -- Memory addressing
    signal addr                 : std_logic_vector(31 downto 0) := x"00000000";
    signal addr_s               : integer range 0 to 7 := 0;
    signal addr_tmp             : integer range 0 to 7 := 0;
    
    
    -- Memory output
    signal data_out             : std_logic_vector(31 downto 0) := (others => '0');


   
begin

--  Memory state
memory_state_process: process (clk)
begin
   if rising_edge(clk) then
       -- State Reset
       if state = STATE_RESET then
            -- Reset Address
            addr_s  <= 0;
            addr    <= (others => '0');
            
            -- Reset color values
            values_red      <= x"0000000000000000";
            values_green    <= x"0000000000000000";
            values_blue     <= x"0000000000000000";

            -- Clear done-flag
            done    <= '0';
    
            
            -- Change state
            state   <= STATE_SETUP;
       
       -- State Setup
       elsif state = STATE_SETUP then
            
            -- Set address out
            addr    <= std_logic_vector(to_unsigned((addr_s*4 + row*32),32));

            -- Change state
            state   <= STATE_LATCH;
       
       -- State Latch
       elsif state = STATE_LATCH then

            -- Write address counter to temporary signal
            addr_tmp <= addr_s;

            -- Write values to color arrays
            values_red(  ((8*addr_tmp)+7) downto (8*addr_tmp)) <= data_out(23 downto 16);
            values_green(((8*addr_tmp)+7) downto (8*addr_tmp)) <= data_out(15 downto 8);
            values_blue( ((8*addr_tmp)+7) downto (8*addr_tmp)) <= data_out(7  downto 0);
            
            
            -- Increment address counter. 
            addr_s    <= addr_s + 1;


           -- If max has been reached go into ready state
            if addr_tmp = 7 then    
                state   <= STATE_READY;
            else 
                
                state   <= STATE_SETUP;
            end if;            
         
       -- State Ready
       elsif state = STATE_READY then
            -- set outputs
            red   <= values_red;
            green <= values_green;
            blue  <= values_blue;
       
            -- set done-flag
            done  <= '1';
            
            -- If the start signal is set. Change state and clear done-flag
            if start = '1' then
                state   <= STATE_RESET;
            end if;
       
        
       else
            state <= STATE_RESET;
       end if;
   end if;
end process;




-- Create instance of row component
block_ram_interface0:LED_RAM_wrapper
port map(
        BRAM_PORTB_0_addr   => addr,
        BRAM_PORTB_0_clk    => clk,
        BRAM_PORTB_0_dout   => data_out,
        BRAM_PORTB_0_en     => '1'
);

end Behavioral;
