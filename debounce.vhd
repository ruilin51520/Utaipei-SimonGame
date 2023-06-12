library IEEE;
use IEEE.std_logic_1164.all;

package debounce is
	component debounce
		port(keyIn: in std_logic;
				 clk: in std_logic;
				 keyOut: out std_logic);
	end component;
end debounce;