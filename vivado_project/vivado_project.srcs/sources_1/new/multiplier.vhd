----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.01.2024 21:47:51
-- Design Name: 
-- Module Name: multiplier - Behavioral
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

entity multiplier is
    Port ( multiplier : in STD_LOGIC_VECTOR (15 downto 0);
           multiplicand : in STD_LOGIC_VECTOR (15 downto 0);
           product : out STD_LOGIC_VECTOR (32 downto 0):= (others => '0');
           clock : in STD_LOGIC;
           reset: in std_logic;
           done : out STD_LOGIC:='0'
        );
end multiplier;

architecture Behavioral of multiplier is
component programmable_carry_adder is
    Port (  sub_control : in STD_LOGIC;
            b : in STD_LOGIC_VECTOR (15 downto 0);
            position : in natural; --starts from 0, max is 31-15
            a : in STD_LOGIC_VECTOR (32 downto 0);
            c : out STD_LOGIC_VECTOR (32 downto 0);
            clock: in std_logic
        );
    end component;
    signal sub_ctrl: std_logic:= '0';
    signal position: natural;
    signal adder_in: std_logic_vector(32 downto 0);
    signal addend: std_logic_vector(15 downto 0);
    signal adder_out: std_logic_vector(32 downto 0);

    type state_type is (give_to_adder, get_from_adder, completed, idle);
    signal state: state_type ;
    signal running_sum: std_logic_vector(32 downto 0):= (others => '0');

begin

--instantiation of the programmable carry adder
adder: programmable_carry_adder port map(
    sub_control => sub_ctrl,
    clock => clock,
    position => position,
    a => adder_in,
    c => adder_out,
    b => multiplicand
);


--process that starts on rising edge of clock
process(clock)
variable shift_count: natural:= 0; --goes from 0 to 16
variable prev_bit: std_logic:= '0'; 
begin
if rising_edge(clock) then
    if reset='0' then
    case state is
        when get_from_adder =>
            running_sum <= adder_out;
            shift_count := shift_count + 1;
            if shift_count > 15 then
                if prev_bit='1' then
                    sub_ctrl <= '0';
                    position <= 16;
                    adder_in <= running_sum;
                    state <= idle;
                    prev_bit := '0';
                else
                    state <= completed;
                end if;
            else
                state <= give_to_adder;
            end if;
        when give_to_adder =>
            if prev_bit=multiplier(shift_count) then
                shift_count := shift_count + 1;
                if shift_count>15 then
                    if prev_bit='1' then
                        sub_ctrl <= '0';
                        position <= 16;
                        adder_in <= running_sum;
                        state <= idle;
                        prev_bit := '0';
                    else
                        state <= completed;
                    end if;
                end if;
            else
                case multiplier(shift_count) is
                    when '1' =>
                        sub_ctrl <= '1';
                    when others =>
                        sub_ctrl <= '0';
                end case;
                prev_bit := multiplier(shift_count);
                position <= shift_count;
                adder_in <= running_sum;
                state <= idle;
            end if;
        when idle =>
            state <= get_from_adder;
        when completed =>
            done <= '1';
            product <= std_logic_vector(running_sum(31 downto 0));
        when others=>
            state <= give_to_adder;
    end case;
    else
        state <= give_to_adder;
        shift_count := 0;
        prev_bit := '0';
        running_sum <= (others => '0');
        done <= '0';
    end if;
end if ;
end process;
end Behavioral;
