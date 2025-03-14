library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm is
    Port ( clk : in STD_LOGIC;
           btn_run : in STD_LOGIC;
           btn_rst : in STD_LOGIC;
           btn_stop: in STD_LOGIC;
           en1 : out STD_LOGIC;
           rst1 : out STD_LOGIC;
           led:out std_logic_vector(2 downto 0));
end fsm;

architecture Behavioral of fsm is
type state_type is (res_chrono, run_chrono, stop_chrono1); -- definim un nou tip de date pentru stari
signal state : state_type := res_chrono; -- starea curenta initializata cu res_chrono
signal next_state : state_type; -- semnal pt urmatoarea stare
begin

reg: process(clk)
begin
    if rising_edge(clk) then
        state <= next_state; -- la fiecare front ascendent de ceas starea curenta primeste valoarea starii urmatoare
    end if;
end process;

next_st: process(state, btn_run, btn_stop, btn_rst)
begin
    --next_state <= state; -- pastreaza stare
    case state is
        when res_chrono =>  
            if btn_run = '1' then
                next_state <= run_chrono;
             else
                next_state <= res_chrono;
            end if;
             led<="100";
        when run_chrono =>
            if btn_stop = '1' then
                next_state <= stop_chrono1;
                else next_state<=run_chrono;
            end if;
            led<="010";
        when stop_chrono1 =>
            if btn_rst = '1' then
                next_state <= res_chrono;
            elsif btn_run = '1' then
                next_state <= run_chrono;
                else next_state<=stop_chrono1;
            end if;
            led<="011";
        when others =>
            next_state <= res_chrono;
            led <= "111";
    end case;
end process;

-- seteaza iesirile pe baza starii curente
with state select
    rst1 <= '1' when res_chrono,
            '0' when others;

with state select
    en1 <= '1' when run_chrono,
            '0' when others;

        
end Behavioral;