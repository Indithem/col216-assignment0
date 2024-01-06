----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.01.2024 21:47:51
-- Design Name: 
-- Module Name: programmable_carry_adder - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity programmable_carry_adder is
    Port (  sub_control : in STD_LOGIC;
            b : in STD_LOGIC_VECTOR (15 downto 0);
            position : in natural; --starts from 0, max is 31-16=15
            a : in STD_LOGIC_VECTOR (31 downto 0);
            c : out STD_LOGIC_VECTOR (31 downto 0);
            clock: in std_logic
        );
end programmable_carry_adder;

architecture Behavioral of programmable_carry_adder is
begin
        
process (clock)
    variable shifted_b:STD_LOGIC_VECTOR (31 downto 0);
    variable aInt,bInt :integer;
    variable temp:integer;
begin
    if rising_edge(clock) then
        aInt:=to_integer(signed(a));
        shifted_b:=(others => '0');
        shifted_b(position+15 downto position):=b;
        bInt:=to_integer(signed(shifted_b));
        case sub_control is
            when '0' =>
                temp:=aInt+bInt;
            when '1' =>
                temp:=aInt-bInt;
            when others =>
                temp:=aInt;
        end case;
        c<=std_logic_vector(to_signed((temp),32));
    end if ;
end process;


end Behavioral;
