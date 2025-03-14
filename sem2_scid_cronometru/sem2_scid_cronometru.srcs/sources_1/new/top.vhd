library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
    Port ( ck : in STD_LOGIC;
           btn_run : in STD_LOGIC;
           btn_stop : in STD_LOGIC;
           btn_rst : in STD_LOGIC;
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           anozi : out STD_LOGIC_VECTOR (3 downto 0);
           dp : out STD_LOGIC;
           led:out std_logic_vector(2 downto 0)
           );
end top;

architecture Behavioral of top is

component driver7seg is
    Port ( ck : in STD_LOGIC;
           led : in unsigned (15 downto 0);
           anozi : out STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           dp : out STD_LOGIC);
end component;

component fsm is
    Port ( clk : in STD_LOGIC;
           btn_run : in STD_LOGIC;
           btn_stop : in STD_LOGIC;
           btn_rst : in STD_LOGIC;
           en1 : out STD_LOGIC;
           rst1 : out STD_LOGIC;
           led:out std_logic_vector(2 downto 0));
end component;

component cronometru is
    Port ( ck : in STD_LOGIC;
           rst1 : in STD_LOGIC;
           en1 : in STD_LOGIC;
           data : out unsigned (15 downto 0));
end component;

component deBounce is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           button_in : in STD_LOGIC;
           pulse_out : out STD_LOGIC);
end component;

signal rst1_int, en1_int : std_logic;
signal led_int : unsigned(15 downto 0);
signal btn_run_db, btn_stop_db, btn_rst_db : std_logic;
--signal led_i:unsigned(2 downto 0);

begin
port_cronometru: cronometru port map(ck => ck, rst1 => rst1_int, en1 => en1_int, data => led_int);
port_fsm: fsm port map(clk => ck, btn_run => btn_run_db, btn_stop => btn_stop_db, btn_rst => btn_rst, en1 => en1_int, rst1 => rst1_int,led => led);
port_driver7seg: driver7seg port map(ck => ck, led => led_int, anozi => anozi, seg => seg, dp => dp);

port_debounce_run: deBounce port map(clk => ck, rst => btn_rst, button_in => btn_run, pulse_out => btn_run_db);
port_debounce_stop: deBounce port map(clk => ck, rst => btn_rst, button_in => btn_stop, pulse_out => btn_stop_db);
--port_debounce_rst: deBounce port map(clk => ck, rst => rst1_int, button_in => btn_rst, pulse_out => btn_rst_db);

end Behavioral;