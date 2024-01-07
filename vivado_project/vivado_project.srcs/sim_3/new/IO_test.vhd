----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.01.2024 18:01:27
-- Design Name: 
-- Module Name: IO_test - Behavioral
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

--textio libraries
use IEEE.STD_LOGIC_TEXTIO.ALL;
use std.textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IO_test is
--  Port ( );
end IO_test;

architecture Behavioral of IO_test is
    file output_file : text open write_mode is "output.txt";
    signal b_signal: std_logic_vector(15 downto 0);
    signal a_signal: std_logic_vector(15 downto 0);
    signal c_signal: std_logic_vector(31 downto 0);
begin
    writing_to_file :process 
        variable line_buffer : line;
        variable i : integer := 0;
    begin
        wait for 10 ns;
        while i < 100 loop
            write(line_buffer, i);
            writeline(output_file, line_buffer);
            i := i + 1;
            wait for 10 ns;
        end loop;
        wait;
    end process;

    reading_from_file : process
        variable input_line : line;
        file input_file : text open read_mode is "cases.txt";
        variable a: natural;
        variable b: natural;
        variable c: natural;
    begin
        wait for 10 ns;
        while not endfile(input_file) loop
            readline(input_file, input_line);
            read(input_line, a);
            read(input_line, b);
            -- read input_line, into c, an unsigned 32 bit value
            read(input_line, c);
            a_signal <= std_logic_vector(to_unsigned(a, 16));
            b_signal <= std_logic_vector(to_unsigned(b, 16));
            c_signal <= std_logic_vector(to_unsigned(c, 32));
            wait for 10 ns;
        end loop;
    end process;

end Behavioral;
