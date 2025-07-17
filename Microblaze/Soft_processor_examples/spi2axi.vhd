-- SPI2AXI Synthesizable RTL (PS-side compatible)
-- Correcciones completas según guías de sintetizabilidad
-- Arquitectura válida para Vivado, GHDL y como IP para MicroBlaze o Zynq

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity spi2axi is
    generic(
        SPI_CPOL       : natural range 0 to 1 := 0;
        SPI_CPHA       : natural range 0 to 1 := 0;
        AXI_ADDR_WIDTH : integer := 32
    );
    port(
        -- SPI interface
        spi_sck    : in  std_logic;
        spi_ss_n   : in  std_logic;
        spi_mosi   : in  std_logic;
        spi_miso   : out std_logic;

        -- Clock & Reset
        axi_aclk    : in  std_logic;
        axi_aresetn : in  std_logic;

        -- AXI Write Address
        s_axi_awaddr  : out std_logic_vector(AXI_ADDR_WIDTH - 1 downto 0);
        s_axi_awprot  : out std_logic_vector(2 downto 0);
        s_axi_awvalid : out std_logic;
        s_axi_awready : in  std_logic;

        -- AXI Write Data
        s_axi_wdata   : out std_logic_vector(31 downto 0);
        s_axi_wstrb   : out std_logic_vector(3 downto 0);
        s_axi_wvalid  : out std_logic;
        s_axi_wready  : in  std_logic;

        -- AXI Read Address
        s_axi_araddr  : out std_logic_vector(AXI_ADDR_WIDTH - 1 downto 0);
        s_axi_arprot  : out std_logic_vector(2 downto 0);
        s_axi_arvalid : out std_logic;
        s_axi_arready : in  std_logic;

        -- AXI Read Data
        s_axi_rdata   : in  std_logic_vector(31 downto 0);
        s_axi_rresp   : in  std_logic_vector(1 downto 0);
        s_axi_rvalid  : in  std_logic;
        s_axi_rready  : out std_logic;

        -- AXI Write Response
        s_axi_bresp   : in  std_logic_vector(1 downto 0);
        s_axi_bvalid  : in  std_logic;
        s_axi_bready  : out std_logic
    );
end entity;

architecture rtl of spi2axi is

    -- Enumerated Types
    type spi_state_t is (SPI_RECEIVE, SPI_PROCESS_RX, SPI_LOAD_TX);
    type axi_state_t is (AXI_IDLE, AXI_WRITE_REQ, AXI_WRITE_RESP, AXI_READ_REQ, AXI_READ_RESP);

    -- Constants
    constant CMD_WRITE : std_logic_vector(7 downto 0) := x"00";
    constant CMD_READ  : std_logic_vector(7 downto 0) := x"01";

    -- SPI Synchronization
    signal spi_sck_sync    : std_logic;
    signal spi_ss_n_sync   : std_logic;
    signal spi_sck_old     : std_logic := '0';

    -- SPI FSM signals
    signal spi_state       : spi_state_t := SPI_RECEIVE;
    signal spi_rx_buffer   : std_logic_vector(87 downto 0) := (others => '0');
    signal spi_rx_count    : integer range 0 to 87 := 0;
    signal spi_tx_byte     : std_logic_vector(7 downto 0) := (others => '0');
    signal spi_miso_int    : std_logic := '0';

    -- AXI FSM signals
    signal axi_state       : axi_state_t := AXI_IDLE;
    signal spi_cmd         : std_logic_vector(7 downto 0) := (others => '0');
    signal spi_addr        : std_logic_vector(31 downto 0) := (others => '0');
    signal spi_wdata       : std_logic_vector(31 downto 0) := (others => '0');
    signal axi_rvalid_reg  : std_logic := '0';
    signal axi_bvalid_reg  : std_logic := '0';

    -- Internal handshake
    signal s_axi_awvalid_int : std_logic := '0';
    signal s_axi_wvalid_int  : std_logic := '0';
    signal s_axi_arvalid_int : std_logic := '0';

begin

    -- Output assignments
    s_axi_awvalid <= s_axi_awvalid_int;
    s_axi_wvalid  <= s_axi_wvalid_int;
    s_axi_arvalid <= s_axi_arvalid_int;
    spi_miso      <= spi_miso_int;

    -- Placeholder: synchronize SPI signals (from external process/module)
    -- TODO: Añadir instancias de sincronizadores externos aquí si se usan clock domains separados

    -- Procesos FSM SPI y AXI se definirán en secciones siguientes.

end architecture;
