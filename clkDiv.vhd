library IEEE;
use IEEE.std_logic_1164.all;

package clkDiv is
	component clkDiv
		port(clk: in std_logic;
				 millisecond: out std_logic;
				 centisecond: out std_logic;
				 decisecond: out std_logic;
				 second: out std_logic);
	end component;
end clkDiv;