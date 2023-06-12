library IEEE;
use IEEE.std_logic_1164.all;

package constants is
	constant SS1: std_logic_vector(2 downto 0) := "101";
	constant SS2: std_logic_vector(2 downto 0) := "000";
	constant SS3: std_logic_vector(2 downto 0) := "001";
	constant SS4: std_logic_vector(2 downto 0) := "010";
	constant SS5: std_logic_vector(2 downto 0) := "011";
	constant SS6: std_logic_vector(2 downto 0) := "100";
	
	constant timekeeping:  std_logic_vector(0 to 1) := "10";
	constant breakthrough: std_logic_vector(0 to 1) := "01";
	constant easy:   std_logic_vector(0 to 2) := "100";
	constant normal: std_logic_vector(0 to 2) := "010";
	constant hard:   std_logic_vector(0 to 2) := "001";
	
	constant durationE: integer := 1500;
	constant durationN: integer := 1000;
	constant durationH: integer := 500;
	constant intervalE: integer := 750;
	constant intervalN: integer := 500;
	constant intervalH: integer := 250;
	constant addScoreE: integer := 1;
	constant addScoreN: integer := 2;
	constant addScoreH: integer := 3;
	
	constant displayMax: positive := 100;
	
	constant noAnsIn: std_logic_vector := "0011";
	constant AI1: std_logic_vector := "1011";
	constant AI2: std_logic_vector := "0111";
	constant AI3: std_logic_vector := "0001";
	constant AI4: std_logic_vector := "0010";
end constants;