

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ocr          pwm duty_cycle
-- FF              100%
-- 80              50%
-- 00              0%

entity m_pwm_generator is
    Port ( 
            counter  : in  unsigned(7 downto 0)          := (others => '0');
            ocr      : in  std_logic_vector (7 downto 0) := (others => '0');
            pwm      : out std_logic                     := '0'
           );
end m_pwm_generator;

architecture Behavioral of m_pwm_generator is

    -- Defines
    constant HIGH : std_logic := '1';
    constant LOW  : std_logic := '0';
    
begin


-- Process that generates PWM
pwm_process:
process(counter)
begin   
    if counter >= unsigned(ocr) then
    -- If counter is over threshold. Set output to low
        pwm <= LOW;
    else
    -- If counter is under threshold. Set output to high
        pwm <= HIGH;
    end if;
end process;

end Behavioral;
