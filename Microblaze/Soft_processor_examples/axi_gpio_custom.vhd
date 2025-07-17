library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity axi_gpio_custom is
    generic(
        C_S_AXI_ADDR_WIDTH : integer := 9;
        C_S_AXI_DATA_WIDTH : integer := 32;
        C_GPIO_WIDTH       : integer := 3;
        C_GPIO2_WIDTH      : integer := 3
    );
    port(
        s_axi_aclk    : in  std_logic;
        s_axi_aresetn : in  std_logic;

        s_axi_awaddr  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        s_axi_awvalid : in  std_logic;
        s_axi_awready : out std_logic;
        s_axi_wdata   : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        s_axi_wstrb   : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
        s_axi_wvalid  : in  std_logic;
        s_axi_wready  : out std_logic;
        s_axi_bresp   : out std_logic_vector(1 downto 0);
        s_axi_bvalid  : out std_logic;
        s_axi_bready  : in  std_logic;

        s_axi_araddr  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        s_axi_arvalid : in  std_logic;
        s_axi_arready : out std_logic;
        s_axi_rdata   : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        s_axi_rresp   : out std_logic_vector(1 downto 0);
        s_axi_rvalid  : out std_logic;
        s_axi_rready  : in  std_logic;

        gpio_io_i     : in  std_logic_vector(C_GPIO_WIDTH-1 downto 0);
        gpio2_io_i    : in  std_logic_vector(C_GPIO2_WIDTH-1 downto 0)
    );
end entity;

architecture rtl of axi_gpio_custom is

    signal axi_arready : std_logic := '0';
    signal axi_rvalid  : std_logic := '0';
    signal axi_rdata   : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');

    signal araddr_reg  : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0) := (others => '0');

begin

    -- Escritura deshabilitada (dummy handshake)
    s_axi_awready <= '1';
    s_axi_wready  <= '1';
    s_axi_bvalid  <= '1';
    s_axi_bresp   <= "00";

    -- Lectura
    s_axi_arready <= axi_arready;
    s_axi_rvalid  <= axi_rvalid;
    s_axi_rdata   <= axi_rdata;
    s_axi_rresp   <= "00";

    process(s_axi_aclk)
    begin
        if rising_edge(s_axi_aclk) then
            if s_axi_aresetn = '0' then
                axi_arready <= '0';
                axi_rvalid  <= '0';
                axi_rdata   <= (others => '0');
                araddr_reg  <= (others => '0');
            else
                -- Captura dirección cuando arvalid y no estamos esperando respuesta
                if (s_axi_arvalid = '1') and (axi_arready = '0') then
                    axi_arready <= '1';
                    araddr_reg  <= s_axi_araddr;
                else
                    axi_arready <= '0';
                end if;

                -- Generar rvalid cuando se ha capturado dirección
                if (axi_arready = '1') then
                    axi_rvalid <= '1';
                    case araddr_reg(3 downto 2) is
                        when "00" =>
                            axi_rdata <= (others => '0');
                            axi_rdata(C_GPIO_WIDTH-1 downto 0) <= gpio_io_i;
                        when "01" =>
                            axi_rdata <= (others => '0');
                            axi_rdata(C_GPIO2_WIDTH-1 downto 0) <= gpio2_io_i;
                        when others =>
                            axi_rdata <= (others => '0');
                    end case;elsif (axi_rvalid = '1' and s_axi_rready = '1') then
                            axi_rvalid <= '0';
                end if;
            end if;
        end if;
    end process;

end architecture;
