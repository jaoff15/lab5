
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;



entity led_matrix is
    Port ( 
           clk      : in  std_logic;
           row      : out std_logic_vector (7 downto 0);
           red      : out std_logic_vector (7 downto 0);
           green    : out std_logic_vector (7 downto 0);
           blue     : out std_logic_vector (7 downto 0));
end led_matrix;

architecture Behavioral of led_matrix is

    component m_row is
        port( 
            counter      : in  unsigned(7 downto 0)             := (others => '0');
            red          : in  std_logic_vector (63 downto 0)   := (others => '0');
            green        : in  std_logic_vector (63 downto 0)   := (others => '0');
            blue         : in  std_logic_vector (63 downto 0)   := (others => '0');
            red_pwm      : out std_logic_vector (7 downto 0)    := (others => '0');
            green_pwm    : out std_logic_vector (7 downto 0)    := (others => '0');
            blue_pwm     : out std_logic_vector (7 downto 0)    := (others => '0')
            );
    end component;
    
    component mem_interface is
        Port ( 
                clk          : in  std_logic;
                start        : in  std_logic                     := '0';
                row          : in  integer range 0 to 7          :=  0;
                done         : out std_logic                     := '0';
                red          : out std_logic_vector(63 downto 0) := (others => '0');
                green        : out std_logic_vector(63 downto 0) := (others => '0');
                blue         : out std_logic_vector(63 downto 0) := (others => '0')
                );
        end component;
        
    -- Define states
    type state_type is (STATE_SHIFT_ROW, STATE_GET, STATE_WAIT, STATE_READY);
    signal state : state_type  := STATE_READY;
    
    -- Color threshold signals
    signal red_sig              : std_logic_vector(63 downto 0) := (others => '0');
    signal green_sig            : std_logic_vector(63 downto 0) := (others => '0');
    signal blue_sig             : std_logic_vector(63 downto 0) := (others => '0');

    -- Color pwm signals
    signal red_threshold        : std_logic_vector(63 downto 0) := (others => '0');
    signal green_threshold      : std_logic_vector(63 downto 0) := (others => '0');
    signal blue_threshold       : std_logic_vector(63 downto 0) := (others => '0');

    -- Prescaled clock counter
    signal counter              : unsigned(7 downto 0)          := (others => '0');
    
    -- clock prescaler
    signal prescaler            : unsigned(63 downto 0)         := (others => '0');

    -- Clock prescalings
    signal pwm_clock            : std_logic                     := '0';
    signal row_clock            : std_logic                     := '0';

    -- Address counter
    signal addr                 : integer range 0 to 7          := 0;

    -- Row counter as integer
    signal row_int              : integer range 0 to 7          := 0;
    
    -- Memory interface signals
    signal start_sig, done_sig  : std_logic                     := '0';

begin

-- Control scaled clocks
pwm_clock <= prescaler(0); 
row_clock <= prescaler(8);


-- Prescale clock
prescale_clock_process: process (clk)
begin
   if rising_edge(clk) then
        prescaler <= prescaler + 1;
   end if;
end process;

-- Increment counter
counter_process: process (pwm_clock)
begin
   if rising_edge(pwm_clock) then
        counter <= counter + 1;
   end if;
end process;

process(row_clock)
    begin
        if rising_edge(row_clock) then
            case state is
                when STATE_SHIFT_ROW =>
                
                    -- Write color values to color thresholds
                    red_threshold     <= red_sig;
                    green_threshold   <= green_sig;
                    blue_threshold    <= blue_sig;
                    
                    -- Get row output
                    case row_int is
                        when 0  => row <= "11111110";
                        when 1  => row <= "11111101";
                        when 2  => row <= "11111011";
                        when 3  => row <= "11110111";
                        when 4  => row <= "11101111";
                        when 5  => row <= "11011111";
                        when 6  => row <= "10111111";
                        when 7  => row <= "01111111";
                        when others => row <= "11111111";
                    end case;
                    
                    -- Change state
                    state <= STATE_GET;
                    
                when STATE_GET =>
                    -- Increment row counter
                    row_int     <= row_int + 1;
                    
                    -- Set start-flag
                    start_sig   <= '1';
                    
                    -- Change state
                    state       <= STATE_WAIT;
                    
                when STATE_WAIT =>
                    -- Reset start-flag
                    start_sig   <= '0';
                    
                    -- Check if done-flag is set
                    if done_sig = '1' then
                        -- If so cahnge state
                        state   <= STATE_READY;
                    end if;
                    
                when STATE_READY =>
                    -- Change state 
                    state <= STATE_SHIFT_ROW;
            end case;
        end if;
end process; 

-- Memory interface
mem_interface0:mem_interface
port map(
    clk          => clk,
    start        => start_sig,
    row          => row_int,
    done         => done_sig,
    red          => red_sig, 
    green        => green_sig,
    blue         => blue_sig
);


-- Create instance of row component
row0:m_row
port map(
    counter     => counter,
    red         => red_threshold,
    green       => green_threshold,
    blue        => blue_threshold,
    red_pwm     => red,
    green_pwm   => green,                                                                                                                                                                                  
    blue_pwm    => blue
);


end Behavioral;
