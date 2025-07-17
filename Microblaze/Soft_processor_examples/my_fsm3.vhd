library IEEE;
use IEEE.std_logic_1164.all;

entity my_fsm3 is
    port (
        X    : in  std_logic;
        CLK  : in  std_logic;
        SET  : in  std_logic;
        Y    : out std_logic_vector(1 downto 0);
        Z2   : out std_logic
    );
end my_fsm3;

architecture fsm3 of my_fsm3 is
    type state_type is (ST0, ST1, ST2);
    signal PS, NS : state_type;
begin

    -- Proceso sincronizado (estado actual)
    sync_proc: process(CLK, SET)
    begin
        if SET = '1' then
            PS <= ST2;
        elsif rising_edge(CLK) then
            PS <= NS;
        end if;
    end process;

    -- Proceso combinacional (próximo estado y salida Mealy)
    comb_proc: process(PS, X)
    begin
        Z2 <= '0';        -- Valor por defecto Mealy
        NS <= PS;         -- Prevención de latch (default assignment)

        case PS is
            when ST0 =>
                -- Moore output is handled separately
                if X = '0' then
                    NS <= ST0;
                    Z2 <= '0';
                else
                    NS <= ST1;
                    Z2 <= '1';
                end if;

            when ST1 =>
                if X = '0' then
                    NS <= ST0;
                    Z2 <= '0';
                else
                    NS <= ST2;
                    Z2 <= '1';
                end if;

            when ST2 =>
                if X = '0' then
                    NS <= ST0;
                    Z2 <= '0';
                else
                    NS <= ST2;
                    Z2 <= '1';
                end if;

            when others =>
                NS <= ST0;
                Z2 <= '1';
        end case;
    end process;

    -- Salida Moore codificada en base al estado
    with PS select
        Y <= "00" when ST0,
             "10" when ST1,
             "11" when ST2,
             "00" when others;

end fsm3;

