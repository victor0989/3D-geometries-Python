library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity meteorite_sensor is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        detect    : out std_logic;
        angle     : out std_logic_vector(8 downto 0);  -- 0-359°
        distance  : out std_logic_vector(9 downto 0);  -- 0-1023 m
        valid     : out std_logic
    );
end meteorite_sensor;

architecture Behavioral of meteorite_sensor is
    signal angle_cnt    : unsigned(8 downto 0) := (others => '0');
    signal distance_cnt : unsigned(9 downto 0) := (others => '0');
    signal detect_reg   : std_logic := '0';
    signal valid_reg    : std_logic := '0';
begin

    process(clk, rst)
    begin
        if rst = '1' then
            angle_cnt    <= (others => '0');
            distance_cnt <= (others => '0');
            detect_reg   <= '0';
            valid_reg    <= '0';
        elsif rising_edge(clk) then
            -- Simulación de escaneo angular (0 a 359)
            if angle_cnt = to_unsigned(359, 9) then
                angle_cnt <= (others => '0');
            else
                angle_cnt <= angle_cnt + 1;
            end if;

            -- Simulación de distancia (0 a 1023)
            if distance_cnt < to_unsigned(1000, 10) then
                distance_cnt <= distance_cnt + 1;
            else
                distance_cnt <= to_unsigned(50, 10); -- nuevo objeto
            end if;

            -- Simulación de detección si dentro de cierto rango
            if distance_cnt < to_unsigned(200, 10) then
                detect_reg <= '1';
            else
                detect_reg <= '0';
            end if;

            valid_reg <= '1';  -- siempre válido
        end if;
    end process;

    -- Salidas
    detect   <= detect_reg;
    angle    <= std_logic_vector(angle_cnt);
    distance <= std_logic_vector(distance_cnt);
    valid    <= valid_reg;

end Behavioral;
