library IEEE;
use IEEE.std_logic_1164.all;
use work.constants.all;

entity chooseMD is
	port(gameStart: in std_logic;
			 GBDone: in boolean;
			 keyboardIn: in integer range -1 to 12;
			 mode: in std_logic_vector(0 to 1);
			 difficulty: in std_logic_vector(0 to 2);
			 duration: out integer range durationH to durationE;
			 interval: out integer range intervalH to intervalE;
			 addScore: out integer range addScoreE to addScoreH;
			 CMDDone: buffer boolean);
end chooseMD;

architecture bev of chooseMD is
begin
	process(gameStart, keyboardIn, mode, difficulty)
		variable initial: boolean := true;
		variable setDone: boolean;
	begin
		if gameStart = '1' then
			if keyboardIn = 11 and (mode = timekeeping or mode = breakthrough)
					and (difficulty = easy or difficulty = normal or difficulty = hard) then
				case difficulty is
					when easy   => duration <= durationE; interval <= intervalE; addScore <= addScoreE;
					when normal => duration <= durationN; interval <= intervalN; addScore <= addScoreN;
					when hard   => duration <= durationH; interval <= intervalH; addScore <= addScoreH;
					when others => NULL;
				end case;
				CMDDone <= true;
			end if;
		else
			CMDDone <= false;
		end if;
	end process;
end bev;