

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity m_row is
    Port ( 
            counter      : in  unsigned(7 downto 0)             := (others => '0');
            red          : in  std_logic_vector (63 downto 0)   := (others => '0');
            green        : in  std_logic_vector (63 downto 0)   := (others => '0');
            blue         : in  std_logic_vector (63 downto 0)   := (others => '0');
            red_pwm      : out std_logic_vector (7 downto 0)    := (others => '0');
            green_pwm    : out std_logic_vector (7 downto 0)    := (others => '0');
            blue_pwm     : out std_logic_vector (7 downto 0)    := (others => '0')
            );
end m_row;

architecture Behavioral of m_row is
    component m_color_channel is
    Port (  
            counter     : in  unsigned(7 downto 0)          := (others => '0');
            red         : in  std_logic_vector(7 downto 0)  := (others => '0');
            green       : in  std_logic_vector(7 downto 0)  := (others => '0');
            blue        : in  std_logic_vector(7 downto 0)  := (others => '0');
            red_pwm     : out std_logic                     := '0';
            green_pwm   : out std_logic                     := '0';
            blue_pwm    : out std_logic                     := '0'
           );
    end component;
begin

-- Generate color channel
gen_color_channels: 
for i in 0 to 7 generate
  m_color_channel_nr: m_color_channel port map
    (   counter     => counter,
        red         => red  (  ((i*8)+7) downto (i*8)),
        green       => green(  ((i*8)+7) downto (i*8)),
        blue        => blue (  ((i*8)+7) downto (i*8)),
        red_pwm     => red_pwm  (i),
        green_pwm   => green_pwm(i),
        blue_pwm    => blue_pwm (i)
    );
end generate gen_color_channels;



end Behavioral;
