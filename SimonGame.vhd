library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.constants.all;

entity SimonGame is
	port(gameStart: in std_logic; -- SW1
			 clk: in std_logic; -- OSC
			 RK: in std_logic_vector(2 downto 0); -- RK1-3
			 mode: in std_logic_vector(0 to 1); -- SW9-10
			 difficulty: in std_logic_vector(0 to 2); -- SW17-19
			 PS: in std_logic_vector(0 to 3); -- PS1-4
			 DE: buffer std_logic_vector(2 downto 0); -- DE3-1
			 SSLED: out std_logic_vector(0 to 7); -- A-DP
			 CDLED: out std_logic_vector(0 to 12); -- COM-L12
			 Row, CR, CG: out std_logic_vector(1 to 8) -- Row1-8, CR1-8, CG1-8
			 );
end SimonGame;

architecture bev of SimonGame is
	use work.clkDiv.all;
--clk: in std_logic
	signal msclk, csclk, dsclk, sclk: std_logic;
	
	use work.debounce.all;
--keyIn: in std_logic
--clk: in std_logic
--keyOut: out std_logic
	
	component keyboard
		port(msclk: in std_logic;
				 RK, DE: in std_logic_vector(2 downto 0);
				 keyboardIn: out integer range -1 to 12;
				 keyboardPress: out std_logic_vector(0 to 3));
	end component;
	shared variable keyboardIn: integer range -1 to 12;
	shared variable keyboardPress: std_logic_vector(0 to 3);

	component chooseMD
		port(gameStart: in std_logic;
				 GBDone: in boolean;
				 keyboardIn: in integer range -1 to 12;
				 mode: in std_logic_vector(0 to 1);
				 difficulty: in std_logic_vector(0 to 2);
				 duration: out integer range durationH to durationE;
				 interval: out integer range intervalH to intervalE;
				 addScore: out integer range addScoreE to addScoreH;
				 CMDDone: buffer boolean);
	end component;
	shared variable duration: integer range durationH to durationE;
	shared variable interval: integer range intervalH to intervalE;
	shared variable addScore: integer range addScoreE to addScoreH;
	shared variable CMDDone: boolean;
	
	component chooseCD
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
	end component;
	shared variable countdown: integer range 0 to 300;
	shared variable CCDDone: boolean;
	
	component gameBody
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
	end component;
	shared variable GBDone: boolean := true;
begin
	instCD: clkDiv port map(clk, msclk, csclk, dsclk, sclk);
	instKB: keyboard port map(msclk, RK, DE, keyboardIn, keyboardPress);
	instCMD: chooseMD port map(gameStart, GBDone, keyboardIn, mode, difficulty, duration, interval, addScore, CMDDone);
	instCCD: chooseCD port map(gameStart, CMDDone, msclk, DE, mode, keyboardIn, keyboardPress, SSLED, countdown, CCDDone);
	instGB: gameBody port map(gameStart, CMDDone, CCDDone, clk, msclk, csclk, mode, PS, duration, countdown, CDLED, Row, CR, CG, GBDone);
	
	process(msclk)
	begin
		if msclk'event and msclk = '1' then
			if DE /= "101" then DE <= DE + 1;
			else DE <= "000";
			end if;
		end if;
	end process;
end bev;