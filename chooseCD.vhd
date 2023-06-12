library IEEE;
use IEEE.std_logic_1164.all;
use work.constants.all;
use work.sevenSegment.all;

entity chooseCD is
	port(gameStart: in std_logic;
			 CMDDone: in boolean;
			 msclk: in std_logic;
			 DE: in std_logic_vector(2 downto 0);
			 mode: in std_logic_vector(0 to 1);
			 keyboardIn: in integer range -1 to 12;
			 keyboardPress: in std_logic_vector(0 to 3);
			 SSLED : out std_logic_vector(0 to 7);
			 countdown: out integer range 0 to 300;
			 CCDDone: buffer boolean);
end chooseCD;

architecture bev of chooseCD is
begin
	process(gameStart, CMDDone)
		variable initialDisplay: boolean := true;
		variable keyIn1, keyIn2, keyIn3: integer range -1 to 12 := -1;
		variable temp: integer range -1 to 12 := 12;
		variable keyDone: boolean := false;
		variable countdownIn: integer := 0;
		variable countdownInDone: boolean := false;
		variable SSLED1, SSLED2, SSLED3: std_logic_vector(0 to 7);
	begin
		if gameStart = '1' and CMDDone then
			if mode = timekeeping then
				if msclk'event and msclk = '1' then
					if keyboardIn /= 11 and keyboardIn /= 12 and keyboardIn /= -1 then
						initialDisplay := false;
						temp := keyboardIn;
						if keyIn1 = -1 and keyDone = false then
							keyIn1 := temp; keyDone := true;
						elsif keyIn2 = -1 and keyDone = false then
							keyIn2 := temp; keyDone := true;
						elsif keyIn3 = -1 and keyDone = false then
							keyIn3 := temp; keyDone := true;
						elsif keyDone = false then
							keyIn1 := temp; keyIn2 := -1; keyIn3 := -1; keyDone := true;
						end if;
					elsif keyboardPress = "0000" and keyDone = true then
						temp := 12; keyDone := false;
					end if;
					
					if keyboardIn = 11 then
						if keyIn3 = -1 then countdownIn := keyIn1 * 10 + keyIn2; countdownInDone := true;
						else countdownIn := keyIn1 * 100 + keyIn2 * 10 + keyIn3; countdownInDone := true;
						end if;
					end if;
					
					if countdownInDone then
						keyIn1 := -1; keyIn2 := -1; keyIn3 := -1;
						countdownInDone := false;
					end if;
					
					if countdownIn mod 30 = 0 and countdownIn >= 30 and countdownIn <= 300 then
						countdown <= countdownIn;
						CCDDone <= true;
					end if;
					
					if initialDisplay then
						sevenSegment(0, SSLED1);
						sevenSegment(0, SSLED2);
						sevenSegment(0, SSLED3);
					else
						sevenSegment(keyIn1, SSLED1);
						sevenSegment(keyIn2, SSLED2);
						sevenSegment(keyIn3, SSLED3);
					end if;
					
					if DE = SS1 then
						SSLED <= SSLED1;
					elsif DE = SS2 then
						SSLED <= SSLED2;
					elsif DE = SS3 then
						SSLED <= SSLED3;
					elsif DE = SS4 or DE = SS5 or DE = SS6 then
						SSLED <= "00000000";
					end if;
				end if;
			else
				CCDDone <= true;
			end if;
		else
			initialDisplay := true;
			keyIn1 := -1; keyIn2 := -1; keyIn3 := -1;
			countdownIn := 0;
			countdownInDone := false;
			SSLED <= "00000000";
			CCDDone <= false;
		end if;
	end process;
end bev;