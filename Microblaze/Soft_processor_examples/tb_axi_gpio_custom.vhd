library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_axi_gpio_custom is
end entity;

architecture sim of tb_axi_gpio_custom is

    constant CLK_PERIOD : time := 10 ns;
    constant MAX_CLK_CYCLES : integer := 1000;  -- límite para evitar loops infinitos

    -- Señales AXI
    signal clk           : std_logic := '0';
    signal resetn        : std_logic := '0';
    signal awaddr        : std_logic_vector(8 downto 0) := (others => '0');
    signal awvalid       : std_logic := '0';
    signal awready       : std_logic;
    signal wdata         : std_logic_vector(31 downto 0) := (others => '0');
    signal wstrb         : std_logic_vector(3 downto 0) := (others => '0');
    signal wvalid        : std_logic := '0';
    signal wready        : std_logic;
    signal bresp         : std_logic_vector(1 downto 0);
    signal bvalid        : std_logic;
    signal bready        : std_logic := '1';
    signal araddr        : std_logic_vector(8 downto 0) := (others => '0');
    signal arvalid       : std_logic := '0';
    signal arready       : std_logic;
    signal rdata         : std_logic_vector(31 downto 0);
    signal rresp         : std_logic_vector(1 downto 0);
    signal rvalid        : std_logic;
    signal rready        : std_logic := '0';

    -- GPIO simulados
    signal gpio_i        : std_logic_vector(2 downto 0) := "101";
    signal gpio2_i       : std_logic_vector(2 downto 0) := "011";

    -- DUT
    component axi_gpio_custom is
        generic (
            C_S_AXI_ADDR_WIDTH : integer := 9;
            C_S_AXI_DATA_WIDTH : integer := 32;
            C_GPIO_WIDTH       : integer := 3;
            C_GPIO2_WIDTH      : integer := 3
        );
        port (
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
    end component;

begin

    -- Clock generator con límite de ciclos para evitar loops infinitos
    clk_process : process
        variable clk_count : integer := 0;
    begin
        while clk_count < MAX_CLK_CYCLES loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
            clk_count := clk_count + 1;
        end loop;
        wait; -- termina el proceso al llegar al máximo
    end process;

    -- Instanciación DUT
    dut : axi_gpio_custom
        port map (
            s_axi_aclk    => clk,
            s_axi_aresetn => resetn,
            s_axi_awaddr  => awaddr,
            s_axi_awvalid => awvalid,
            s_axi_awready => awready,
            s_axi_wdata   => wdata,
            s_axi_wstrb   => wstrb,
            s_axi_wvalid  => wvalid,
            s_axi_wready  => wready,
            s_axi_bresp   => bresp,
            s_axi_bvalid  => bvalid,
            s_axi_bready  => bready,
            s_axi_araddr  => araddr,
            s_axi_arvalid => arvalid,
            s_axi_arready => arready,
            s_axi_rdata   => rdata,
            s_axi_rresp   => rresp,
            s_axi_rvalid  => rvalid,
            s_axi_rready  => rready,
            gpio_io_i     => gpio_i,
            gpio2_io_i    => gpio2_i
        );

    -- Proceso de estímulo
    stimulus : process
    begin
        wait for 20 ns;
        resetn <= '1';

        wait for 40 ns;

        -- Lectura GPIO 1 (0x00)
        araddr  <= (others => '0');  -- dirección base
        arvalid <= '1';
        wait until arready = '1';
        arvalid <= '0';

        wait until rvalid = '1';
        rready <= '1';
        wait for 10 ns;
        rready <= '0';
        report "Leído GPIO 1: " & integer'image(to_integer(unsigned(rdata(2 downto 0))));

        -- Lectura GPIO 2 (0x04)
        wait for 30 ns;
        araddr  <= (8 downto 0 => '0');
        araddr(2) <= '1'; -- 0x04 = 000000100 binario
        arvalid <= '1';
        wait until arready = '1';
        arvalid <= '0';

        wait until rvalid = '1';
        rready <= '1';
        wait for 10 ns;
        rready <= '0';
        report "Leído GPIO 2: " & integer'image(to_integer(unsigned(rdata(2 downto 0))));

        wait; -- esperar indefinidamente
    end process;

end architecture;

