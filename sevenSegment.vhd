library IEEE;
use IEEE.std_logic_1164.all;

package sevenSegment is
	procedure sevenSegment(
		num: in integer range -1 to 12;
		SSLED: out std_logic_vector(0 to 7));
end sevenSegment;

package body sevenSegment is
	procedure sevenSegment (
		num: in integer range -1 to 12;
		SSLED: out std_logic_vector(0 to 7)) is
	begin
		case num is
			when  0 => SSLED := "11111100";
			when  1 => SSLED := "01100000";
			when  2 => SSLED := "11011010";
			when  3 => SSLED := "11110010";
			when  4 => SSLED := "01100110";
			when  5 => SSLED := "10110110";
			when  6 => SSLED := "10111110";
			when  7 => SSLED := "11100000";
			when  8 => SSLED := "11111110";
			when  9 => SSLED := "11110110";
			when 10 => SSLED := "00110010"; -- *
			when 11 => SSLED := "00011010"; -- #
			when 12 => SSLED := "00000001"; -- none
			when others => SSLED := "00000000";
		end case;
	end sevenSegment;
end sevenSegment;