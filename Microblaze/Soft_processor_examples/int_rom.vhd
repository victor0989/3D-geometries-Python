library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  -- en lugar de std_logic_unsigned

entity int_rom is
    Port (
        addr : in std_logic_vector(10 downto 0);
        data : out std_logic_vector(7 downto 0)
    );
end int_rom;

architecture Behavioral of int_rom is
    type rom_type is array (0 to 2047) of std_logic_vector(7 downto 0); -- 2Kx8 ROM
    signal ROM : rom_type := (
        0 => x"00", 1 => x"01", 2 => x"02", -- Puedes personalizar esto
        others => x"00"
    );
begin
    data <= ROM(to_integer(unsigned(addr)));  -- Convierte la dirección a entero
end Behavioral;
