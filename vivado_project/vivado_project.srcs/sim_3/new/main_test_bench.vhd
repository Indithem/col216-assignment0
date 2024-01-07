----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.01.2024 15:16:57
-- Design Name: 
-- Module Name: main_test_bench - Behavioral
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
use ieee.std_logic_textio.all;
use std.textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main_test_bench is
--  Port ( );
end main_test_bench;

architecture Behavioral of main_test_bench is
    component multiplier is
        Port ( multiplier : in STD_LOGIC_VECTOR (15 downto 0);
               multiplicand : in STD_LOGIC_VECTOR (15 downto 0);
               product : out STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
               clock : in STD_LOGIC;
               done : out STD_LOGIC;
               reset : in STD_LOGIC 
            );
        end component;
    
        signal a_signal: std_logic_vector(15 downto 0);
        signal b_signal: std_logic_vector(15 downto 0);
        signal clock: std_logic:='0';
        signal done: std_logic;
        signal reset: std_logic:='1';
        signal cs1221620: std_logic_vector(31 downto 0);
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
    product => cs1221620,
    clock => clock,
    done => done,
    reset => reset
);

process (clock)
begin
    if rising_edge(clock) then
        if done='0' then
            cycles_count <= cycles_count + 1;
        elsif reset='1' then
            cycles_count <= 0;
        end if;
    end if;
end process;

stim_proc: process
    file input_file: text open read_mode is "cases.txt";
    file output_file: text open write_mode is "output.txt";
    variable input_line: line;
    variable output_line: line;
    variable a: natural;
    variable b: natural;
    variable c: natural;

begin
    while not endfile(input_file) loop
        readline(input_file, input_line);
        read(input_line, a);
        read(input_line, b);
        read(input_line, c);
        a_signal <= std_logic_vector(to_unsigned(a, 16));
        b_signal <= std_logic_vector(to_unsigned(b, 16));
        reset <= '1';
        wait until rising_edge(clock);
        reset <= '0';
        wait until done = '1';
        assert std_logic_vector(to_unsigned(c,32))=cs1221620 report "Error" severity error;
        write(output_line, a);
        write(output_line, string'(" "));
        write(output_line, b);
        write(output_line, string'(" "));
        write(output_line, cs1221620);
        write(output_line, string'(" "));
        write(output_line, cycles_count);
        writeline(output_file, output_line);
    end loop;
end process;
end Behavioral;
