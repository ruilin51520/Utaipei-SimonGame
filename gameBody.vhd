library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.constants.all;
use work.debounce.all;

entity gameBody is
	port(gameStart: in std_logic;
			 CMDDone, CCDDone: in boolean;
			 clk, msclk, csclk: in std_logic;
			 mode: in std_logic_vector(0 to 1);
			 PS: in std_logic_vector(0 to 3);
			 duration: in integer;
			 countdown: in integer range 0 to 300;
			 CDLED: out std_logic_vector(0 to 12);
			 Row, CR, CG: out std_logic_vector(1 to 8);
			 GBDone: buffer boolean);
end gameBody;

architecture bev of gameBody is
	type intArray is array (integer range <>) of integer;
	
	shared variable pulseIn: std_logic_vector(0 to 3);
	shared variable displayArray, ansInArray: intArray(1 to displayMax);
	shared variable nowDisplay, indexDisplay, indexAnsIn: positive range 1 to displayMax := 1;
	shared variable randomValue: integer range 1 to 4;
	shared variable displayDone: boolean := true;
	shared variable ansInDone: boolean:= false;
	shared variable ansIn: integer range 1 to 4;
begin
	instDB1: debounce port map(PS(0), csclk, pulseIn(0));
	instDB2: debounce port map(PS(1), csclk, pulseIn(1));
	instDB3: debounce port map(PS(2), csclk, pulseIn(2));
	instDB4: debounce port map(PS(3), csclk, pulseIn(3));
	
	process(clk)
		variable count: integer range 0 to (durationE * 10000) := 0;
		variable countMax: integer := duration * 10000;
		constant oneSecond: integer := 10000000;
		variable countTurnOff: integer range 0 to 250000000 := 0;
		variable countTurnOffMax: integer := countdown * oneSecond / 12;
		variable countTurnOffTimes: integer range 0 to 12 := 0;
	begin
	if gameStart = '1' and CMDDone and CCDDone then
		if clk'event and clk = '1' then
			randomValue := count mod 4 + 1;
			
			if displayDone and nowDisplay < displayMax and ansInArray = displayArray
					and randomValue /= displayArray(nowDisplay) then
				nowDisplay := nowDisplay + 1;
				displayArray(nowDisplay) := randomValue;
				displayDone := false;
				indexAnsIn := 1;
			end if;
			
			if displayDone then
				if pulseIn /= "0011" then
					case pulseIn is
						when "1011" => ansIn := 1;
						when "0111" => ansIn := 2;
						when "0001" => ansIn := 3;
						when "0010" => ansIn := 4;
						when others => NULL;
					end case;
					ansInDone := true;
				elsif pulseIn = "0011" and ansInDone then
					indexAnsIn := indexAnsIn + 1;
					ansInArray(indexAnsIn) := ansIn;
					ansInDone := false;
				end if;
			end if;
			
			if not displayDone and count = countMax then
				if indexDisplay < nowDisplay then
					indexDisplay := indexDisplay + 1;
				else
					indexDisplay := 1;
					displayDone := true;
				end if;
			end if;
			
			if mode = timekeeping then
				case countTurnOffTimes is
					when  0 => CDLED <= "1111111111111";
					when  1 => CDLED <= "1111111111110";
					when  2 => CDLED <= "1111111111100";
					when  3 => CDLED <= "1111111111000";
					when  4 => CDLED <= "1111111110000";
					when  5 => CDLED <= "1111111100000";
					when  6 => CDLED <= "1111111000000";
					when  7 => CDLED <= "1111110000000";
					when  8 => CDLED <= "1111100000000";
					when  9 => CDLED <= "1111000000000";
					when 10 => CDLED <= "1110000000000";
					when 11 => CDLED <= "1100000000000";
					when 12 => CDLED <= "1000000000000"; GBDone <= true;
				end case;
			elsif mode = breakthrough then
				case nowDisplay - 2 is
					when  0 => CDLED <= "1000000000000";
					when  1 => CDLED <= "1100000000000";
					when  2 => CDLED <= "1110000000000";
					when  3 => CDLED <= "1111000000000";
					when  4 => CDLED <= "1111100000000";
					when  5 => CDLED <= "1111110000000";
					when  6 => CDLED <= "1111111000000";
					when  7 => CDLED <= "1111111100000";
					when  8 => CDLED <= "1111111110000";
					when  9 => CDLED <= "1111111111000";
					when 10 => CDLED <= "1111111111100";
					when 11 => CDLED <= "1111111111110";
					when 12 => CDLED <= "1111111111111"; GBDone <= true;
					when others => NULL;
				end case;
			end if;
			
			if count /= countMax then count := count + 1;
			else count := 0;
			end if;
			
			if countTurnOff /= countTurnOffMax then countTurnOff := countTurnOff + 1;
			else countTurnOffTimes := countTurnOffTimes + 1; countTurnOff := 0;
			end if;
		end if;
	else
		displayArray := (others => 0); ansInArray := (others => 0);
		nowDisplay := 1; indexDisplay := 1; indexAnsIn := 1;
		displayDone := true;
		ansInDone := false;
		countTurnOff := 0;
		countTurnOffTimes := 0;
		CDLED <= "1000000000000";
	end if;
	end process;
	
	process(msclk)
		variable step: integer range 1 to 5;
	begin
	if gameStart = '1' then
		if CMDDone and CCDDone then
			if msclk'event and msclk = '1' then
				case step is
				when 1 =>
					Row <= "10000000";
					CR  <= "11111111";
					CG  <= "11111111";
					step := 2;
				when 2 =>
					Row <= "11111111";
					CR  <= "00000001";
					CG  <= "00000001";
					step := 3;
				when 3 =>
					Row <= "00000001";
					CR  <= "11111111";
					CG  <= "11111111";
					step := 4;
				when 4 =>
					Row <= "11111111";
					CR  <= "10000000";
					CG  <= "10000000";
					step := 5;
				when 5 =>
					case displayArray(indexDisplay) is
					when 1 =>
						Row <= "01110000";
						CR  <= "00000000";
						CG  <= "01110000";
					when 2 =>
						Row <= "01110000";
						CR  <= "00001110";
						CG  <= "00000000";
					when 3 =>
						Row <= "00001110";
						CR  <= "01110000";
						CG  <= "00000000";
					when 4 =>
						Row <= "00001110";
						CR  <= "00000000";
						CG  <= "00001110";
					when others => NULL;
					end case;
					step := 1;
				end case;
			end if;
		end if;
	else
		Row <= "00000000";
		CR  <= "00000000";
		CG  <= "00000000";
	end if;
	end process;
end bev;