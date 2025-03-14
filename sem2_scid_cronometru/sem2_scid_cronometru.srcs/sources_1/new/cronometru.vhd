library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cronometru is
    Port ( ck : in STD_LOGIC;
           rst1 : in STD_LOGIC;
           en1 : in STD_LOGIC;
           data : out unsigned (15 downto 0));
end cronometru;

architecture Behavioral of cronometru is

constant const_div : integer := 10**6; -- constanta de divizare a frecventei de ceas, fck de pe basys3=100MHZ
signal cnt_div : integer range 0 to const_div-1; -- numaratorul pentru divizorul de frecventa
signal ck_div : std_logic; -- frecventa de ceas obtinuta in urma divizarii=100Hz
signal cnt_bcd : unsigned(15 downto 0); -- numaratorul pentru cronometru

begin

-- divizor de frecventa
div_ck: process(ck, rst1)
begin 
    if rst1 = '1' then
        cnt_div <= 0; -- numaratorul incepe sa numere de la inceput
    elsif rising_edge(ck) and en1 = '1' then -- numaratorul numara doar pe front crescator si semnalul de activare este activat
        if cnt_div = const_div-1 then -- daca numaratorul ajunge la sfarsitul unui ciclu complet
            cnt_div <= 0;
            ck_div <= '1';
        else
            cnt_div <= cnt_div + 1;
            ck_div <= '0';--de 
        end if;
    end if;
end process;

-- numarator pentru cronometru
num_bcd: process(ck_div, rst1)
begin
    if rst1 = '1' then
        cnt_bcd <= (others => '0');
    elsif rising_edge(ck_div) and en1 = '1' then
        if cnt_bcd(3 downto 0) = "1001" then
            cnt_bcd(3 downto 0) <= "0000";
            if cnt_bcd(7 downto 4) = "1001" then
                cnt_bcd(7 downto 4) <= "0000";
                if cnt_bcd(11 downto 8) = "1001" then
                    cnt_bcd(11 downto 8) <= "0000";
                    if cnt_bcd(15 downto 12) = "1001" then
                        cnt_bcd(15 downto 12) <= "0000";
                    else
                        cnt_bcd(15 downto 12) <= cnt_bcd(15 downto 12) + 1;
                    end if;
                else
                    cnt_bcd(11 downto 8) <= cnt_bcd(11 downto 8) + 1;
                end if;
            else
                cnt_bcd(7 downto 4) <= cnt_bcd(7 downto 4) + 1;
            end if;
        else
            cnt_bcd(3 downto 0) <= cnt_bcd(3 downto 0) + 1;
        end if;
    end if;
end process;

data <= cnt_bcd;
end Behavioral;