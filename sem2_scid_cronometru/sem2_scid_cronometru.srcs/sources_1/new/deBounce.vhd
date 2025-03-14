library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity deBounce is
    port(   clk : in std_logic;
            rst : in std_logic;
            button_in : in std_logic;
            pulse_out : out std_logic --semnal de iesire care indica faptil ca butonul a fost apasat si stabilizat
        );
end DeBounce;

architecture behav of deBounce is

--the below constants decide the working parameters.
--the higher this is, the more longer time the user has to press the button.
constant COUNT_MAX : integer := 10000000; --determin? num?rul de cicluri de ceas pentru care butonul trebuie men?inut ap?sat pentru a considera c? semnalul este stabilizat
--set it '1' if the button creates a high pulse when its pressed, otherwise '0'.
constant BTN_ACTIVE : std_logic := '1';

signal count : integer := 0;  --contor folosit pt a masura durata in care butonul este apasat
type state_type is (idle,wait_time); --state machine
signal state : state_type := idle;

begin
  
process(rst,clk)
begin
    if(rst = '1') then
        state <= idle;
        pulse_out <= '0';
       
   elsif(rising_edge(clk)) then
        case (state) is
            when idle =>
                if(button_in = BTN_ACTIVE) then  
                    state <= wait_time;
                  
                else
                    state <= idle; --wait until button is pressed.
                end if;
                pulse_out <= '0';
            when wait_time =>
                if(count = COUNT_MAX) then
                    count <= 0;
                    if(button_in = BTN_ACTIVE) then
                        pulse_out <= '1';
                    
                    end if;
                    
                    state <= idle;  
                else
                    count <= count + 1;
                end if; 
        end case;       
    end if;        
end process;                  
                                                                                
end architecture behav;