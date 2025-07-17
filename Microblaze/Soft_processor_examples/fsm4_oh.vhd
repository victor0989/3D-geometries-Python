library IEEE;
use IEEE.std_logic_1164.all;

-- Entity
entity my_fsm4_oh is
   port (
      X     : in  std_logic;
      CLK   : in  std_logic;
      RESET : in  std_logic;
      Y     : out std_logic_vector(3 downto 0); -- One-hot
      Z1    : out std_logic;
      Z2    : out std_logic
   );
end my_fsm4_oh;

-- Architecture
architecture fsm4_oh of my_fsm4_oh is

   type state_type is (ST0, ST1, ST2, ST3);

   -- Codificación one-hot explícita
   attribute ENUM_ENCODING: STRING;
   attribute ENUM_ENCODING of state_type: type is "1000 0100 0010 0001";

   signal PS, NS : state_type;

begin

   -- Proceso de registro (estado actual)
   sync_proc : process(CLK, RESET)
   begin
      if RESET = '1' then
         PS <= ST0;
      elsif rising_edge(CLK) then
         PS <= NS;
      end if;
   end process;

   -- Proceso combinacional (próximo estado y salidas)
   comb_proc : process(PS, X)
   begin
      -- Valores por defecto
      Z1 <= '1';
      Z2 <= '0';
      NS <= PS;

      case PS is
         when ST0 =>
            Z1 <= '1'; -- Moore
            if X = '0' then
               NS <= ST1;
               Z2 <= '0';
            else
               NS <= ST0;
               Z2 <= '1';
            end if;

         when ST1 =>
            Z1 <= '1';
            if X = '0' then
               NS <= ST2;
               Z2 <= '0';
            else
               NS <= ST1;
               Z2 <= '1';
            end if;

         when ST2 =>
            Z1 <= '0';
            if X = '0' then
               NS <= ST3;
               Z2 <= '0';
            else
               NS <= ST2;
               Z2 <= '1';
            end if;

         when ST3 =>
            Z1 <= '1';
            if X = '0' then
               NS <= ST0;
               Z2 <= '0';
            else
               NS <= ST3;
               Z2 <= '1';
            end if;

         when others =>
            Z1 <= '1';
            Z2 <= '0';
            NS <= ST0;
      end case;
   end process;

   -- Codificación de estado (one-hot) para salida Y
   with PS select
      Y <= "1000" when ST0,
           "0100" when ST1,
           "0010" when ST2,
           "0001" when ST3,
           "1000" when others;

end fsm4_oh;
