library IEEE;
use IEEE.std_logic_1164.all;
library ieee;
use IEEE.STD_LOGIC_TEXTIO.all;
use STD.TEXTIO.all;
entity testbench is
end testbench;
architecture testbench_arch of testbench is
  component stopwatch
    port
    (
      CLK       : in std_logic;
      RESET     : in std_logic;
      STRTSTOP  : in std_logic;
      TENTHSOUT : out std_logic_vector (9 downto 0);
      ONESOUT   : out std_logic_vector (6 downto 0);
      TENSOUT   : out std_logic_vector (6 downto 0)
    );
  end component;
  signal CLK           : std_logic;
  signal RESET         : std_logic;
  signal STRTSTOP      : std_logic;
  signal TENTHSOUT     : std_logic_vector (9 downto 0);
  signal ONESOUT       : std_logic_vector (6 downto 0);
  signal TENSOUT       : std_logic_vector (6 downto 0);
  constant ClockPeriod : time := 60 ns;
  file RESULTS         : TEXT is out "results.txt";
  signal i             : std_logic;
begin
  UUT : stopwatch
  port map
  (
    CLK       => CLK,
    RESET     => RESET,
    STRTSTOP  => STRTSTOP,
    TENTHSOUT => TENTHSOUT,
    ONESOUT   => ONESOUT,
    TENSOUT   => TENSOUT
  );
  stimulus : process
  begin
    reset    <= '1';
    strtstop <= '1';
    wait for 240 ns;
    reset    <= '0';
    strtstop <= '0';
    wait for 5000 ns;
    strtstop <= '1';
    wait for 8125 ns;
    strtstop <= '0';
    wait for 500 ns;
    strtstop <= '1';
    wait for 875 ns;
    reset <= '1';
    wait for 375 ns;
    reset <= '0';
    wait for 700 ns;
    strtstop <= '0';
    wait for 550 ns;
    strtstop <= '1';
  end process stimulus;
  clock : process
  begin
    clk <= '1';
    wait for 100 ns;
    loop
      wait for (ClockPeriod / 2);
      CLK <= not CLK;
    end loop;
  end process clock;
  check_results : process
    variable tmptenthsout                    : std_logic_vector(9 downto 0);
    variable l                               : line;
    variable good_val, good_number, errordet : boolean;
    variable r                               : real;
    variable vector_time                     : time;
    variable space                           : character;
    file vector_file                         : text is in "values.txt";
  begin
    while not endfile(vector_file) loop
      readline(vector_file, l);
      read(l, r, good => good_number);
      next when not good_number;
      vector_time := r * 1 ns;
      if (now < vector_time) then
        wait for vector_time - now;
      end if;
      read(l, space);
      read(l, tmptenthsout, good_val);
      assert good_val report "bad tenthsoutvalue";
      wait for 10 ns;
      if (tmptenthsout /= tenthsout) then
        assert errordet report "vector mismatch";
      end if;
    end if;
  end loop;
  wait;
end process check_results;
end testbench_arch;
library XilinxCoreLib;
configuration stopwatch_cfg of testbench is
  for testbench_arch
    for all : stopwatch use configuration work.cfg_tenths;
  end for;
end for;
end stopwatch_cfg;

-- Vector file containing expected results
0 1111111110
340 1111111110
400 1111111101
460 1111111011
520 1111110111
580 1111101111
640 1111011111
700 1110111111
760 1101111111
820 1011111111
880 0111111111
940 1111111110
1000 1111111110
1060 1111111101
1120 1111111011
1180 1111110111
1240 1111101111
1300 1111011111
1360 1110111111
1420 1101111111
1480 1011111111
1540 0111111111
1600 1111111110
1660 1111111110
1720 1111111101
1780 1111111011