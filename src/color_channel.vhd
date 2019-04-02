

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity m_color_channel is
    Port ( 
            counter   : in  unsigned(7 downto 0)            := (others => '0');
            red       : in  std_logic_vector (7 downto 0)   := (others => '0');
            green     : in  std_logic_vector (7 downto 0)   := (others => '0');
            blue      : in  std_logic_vector (7 downto 0)   := (others => '0');
            red_pwm   : out std_logic                       := '0';
            green_pwm : out std_logic                       := '0';
            blue_pwm  : out std_logic                       := '0'
           );
end m_color_channel;

architecture Behavioral of m_color_channel is
    component m_pwm_generator is
    Port (  
            counter : in  unsigned(7 downto 0)              := (others => '0');
            ocr     : in  std_logic_vector(7 downto 0);
            pwm     : out std_logic                         := '0'
           );
    end component;
begin

-- The red LED
pwm_generator_r:m_pwm_generator
port map(
    counter => counter,
    ocr     => red,
    pwm     => red_pwm
);


-- The green LED
pwm_generator_g:m_pwm_generator
port map(
    counter => counter,
    ocr     => green,
    pwm     => green_pwm
);

-- The blue LED
pwm_generator_b:m_pwm_generator
port map(
    counter => counter,
    ocr     => blue,
    pwm     => blue_pwm
);

end Behavioral;
