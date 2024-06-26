----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.01.2024 12:02:27
-- Design Name: 
-- Module Name: tb_multiplier - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_multiplier is
    generic (
        constant a: natural:=65535;
        constant b: natural:=65535
    );
end tb_multiplier;

architecture Behavioral of tb_multiplier is
    component multiplier is
    Port ( multiplier : in STD_LOGIC_VECTOR (15 downto 0);
           multiplicand : in STD_LOGIC_VECTOR (15 downto 0);
           product : out STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
           clock : in STD_LOGIC;
           done : out STD_LOGIC;
           reset : in STD_LOGIC 
        );
    end component;

    signal a_signal: std_logic_vector(15 downto 0):=std_logic_vector(to_unsigned(a,16));
    signal b_signal: std_logic_vector(15 downto 0):=std_logic_vector(to_unsigned(b,16));
    signal clock: std_logic:='0';
    signal done: std_logic;
    signal reset: std_logic:='1';
    signal c: std_logic_vector(31 downto 0);
    signal cycles_count: integer:=0;
begin

-- process to run clock for every 5ns
clk_process: process
begin
    wait for 5 ns;
    clock <= not clock;
end process;

uut: multiplier port map(
    multiplier => a_signal,
    multiplicand => b_signal,
    product => c,
    clock => clock,
    done => done,
    reset => reset
);

--process that resets signal to 1 for 10ns then back to 0
reset_process: process
begin
    reset <= '1';
    wait for 10 ns;
    reset <= '0';
    wait;
end process;

--process to increment cycles_count untill done is high
process(clock)
begin
    if rising_edge(clock) and done = '0' then
        cycles_count <= cycles_count + 1;
    end if;
end process;


end Behavioral;
