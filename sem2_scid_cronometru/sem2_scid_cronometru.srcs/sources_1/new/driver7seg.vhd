library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity driver7seg is
    Port ( ck : in STD_LOGIC;
           led : in unsigned (15 downto 0);--numarul care trebuie sa se afiseze pe display
           anozi : out STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);--7 catozi pentru 7 segmente
           dp : out STD_LOGIC);-- catodul pt punctul zecimal
end driver7seg;

architecture Behavioral of driver7seg is
signal cnt_div:unsigned(19 downto 0);
alias select_anod is cnt_div(19 downto 18);
signal cifra:unsigned(3 downto 0);

begin

--divizorul de frecventa pentru display
div:process(ck)
begin
    if rising_edge(ck) then
        cnt_div<=cnt_div+1;
    end if;
end process;

--2:4 dcd pentru a activa anodul necesar
with select_anod select
anozi<="1110" when "00",
       "1101" when "01",
       "1011" when "10",
       "0111" when others;
       
--mux 4:1 pentru a extrage valoarea cifrei
with select_anod select
cifra<=led(3 downto 0) when "00",
       led(7 downto 4) when "01",
       led(11 downto 8) when "10",
       led(15 downto 12)when others;

--decoder 7 seg
    with cifra SELect
   seg<= "1111001" when "0001",   --1
         "0100100" when "0010",   --2
         "0110000" when "0011",   --3
         "0011001" when "0100",   --4
         "0010010" when "0101",   --5
         "0000010" when "0110",   --6
         "1111000" when "0111",   --7
         "0000000" when "1000",   --8
         "0010000" when "1001",   --9
         "0001000" when "1010",   --A
         "0000011" when "1011",   --b
         "1000110" when "1100",   --C
         "0100001" when "1101",   --d
         "0000110" when "1110",   --E
         "0001110" when "1111",   --F
         "1000000" when others;   --0


--mux 2:1 pentru punctul zecimal
with select_anod select
dp<='0' when "10",
    '1' when others;

end Behavioral;