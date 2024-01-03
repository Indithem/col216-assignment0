----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.01.2024 22:33:46
-- Design Name: 
-- Module Name: adder_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity adder_tb is
--  Port ( );
end adder_tb;

architecture Behavioral of adder_tb is
    signal clk: std_logic:='0';
    component programmable_carry_adder is
        Port (  sub_control : in STD_LOGIC;
            b : in STD_LOGIC_VECTOR (15 downto 0);
            position : in natural;
            a : in STD_LOGIC_VECTOR (32 downto 0);
            c : out STD_LOGIC_VECTOR (32 downto 0);
            clock: in std_logic
    );
    end component;
    signal position : natural :=0;
    signal sub_cont : std_logic := '1';
    signal b :  STD_LOGIC_VECTOR (15 downto 0):=x"0001";
    signal a :  STD_LOGIC_VECTOR (32 downto 0):=((others => '0'));
    signal c : std_logic_vector(32 downto 0);
begin

process
begin
wait for 5ns;
clk <= not clk;
end process ;

uut: programmable_carry_adder port map(
    sub_control => sub_cont,
    b => b,
    position => position,
    a => a,
    c => c,
    clock => clk
);

end Behavioral;
