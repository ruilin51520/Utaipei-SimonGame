library IEEE;
use IEEE.std_logic_1164.all;

entity keyboard is
	port(msclk: in std_logic;
			 RK, DE: in std_logic_vector(2 downto 0);
			 keyboardIn: out integer range -1 to 12;
			 keyboardPress: out std_logic_vector(0 to 3));
end keyboard;

architecture bev of keyboard is
begin
	process(DE)
	begin
		if msclk'event and msclk = '1' then
			if DE = "000" then case RK is
				when "011" => keyboardIn <=  1; keyboardPress(0) <= '1';
				when "101" => keyboardIn <=  2; keyboardPress(0) <= '1';
				when "110" => keyboardIn <=  3; keyboardPress(0) <= '1';
				when "111" => keyboardIn <= 12; keyboardPress(0) <= '0';
				when others => keyboardIn <= -1;
				end case;
			elsif DE = "001" then case RK is
				when "011" => keyboardIn <=  4; keyboardPress(1) <= '1';
				when "101" => keyboardIn <=  5; keyboardPress(1) <= '1';
				when "110" => keyboardIn <=  6; keyboardPress(1) <= '1';
				when "111" => keyboardIn <= 12; keyboardPress(1) <= '0';
				when others => keyboardIn <= -1;
				end case;
			elsif DE = "010" then case RK is
				when "011" => keyboardIn <=  7; keyboardPress(2) <= '1';
				when "101" => keyboardIn <=  8; keyboardPress(2) <= '1';
				when "110" => keyboardIn <=  9; keyboardPress(2) <= '1';
				when "111" => keyboardIn <= 12; keyboardPress(2) <= '0';
				when others => keyboardIn <= -1;
				end case;
			elsif DE = "011" then case RK is
				when "011" => keyboardIn <= 10; keyboardPress(3) <= '1';
				when "101" => keyboardIn <=  0; keyboardPress(3) <= '1';
				when "110" => keyboardIn <= 11; keyboardPress(3) <= '1';
				when "111" => keyboardIn <= 12; keyboardPress(3) <= '0';
				when others => keyboardIn <= -1;
				end case;
			end if;
		end if;
	end process;
end bev;