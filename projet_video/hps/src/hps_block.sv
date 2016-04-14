`timescale 1 ps / 1 ps

// YM/TPT : Encapsulate an hps module in a hps_block using interfaces 
// in order to have less declarations to do for hps instanciation
//
module hps_block (
                 // Whisbone part
                 wshb_if wshb_ifm,
                 // HPS part
                 inout wire              HPS_CONV_USB_N,
                 output wire      [14:0] HPS_DDR3_ADDR,
                 output wire      [2:0]  HPS_DDR3_BA,
                 output wire             HPS_DDR3_CAS_N,
                 output wire             HPS_DDR3_CKE,
                 output wire             HPS_DDR3_CK_N,
                 output wire             HPS_DDR3_CK_P,
                 output wire             HPS_DDR3_CS_N,
                 output wire      [3:0]  HPS_DDR3_DM,
                 inout wire       [31:0] HPS_DDR3_DQ,
                 inout wire       [3:0]  HPS_DDR3_DQS_N,
                 inout wire       [3:0]  HPS_DDR3_DQS_P,
                 output wire             HPS_DDR3_ODT,
                 output wire             HPS_DDR3_RAS_N,
                 output wire             HPS_DDR3_RESET_N,
                 input wire              HPS_DDR3_RZQ,
                 output wire             HPS_DDR3_WE_N,
                 output wire             HPS_ENET_GTX_CLK,
                 inout wire              HPS_ENET_INT_N,
                 output wire             HPS_ENET_MDC,
                 inout wire              HPS_ENET_MDIO,
                 input wire              HPS_ENET_RX_CLK,
                 input wire       [3:0]  HPS_ENET_RX_DATA,
                 input wire              HPS_ENET_RX_DV,
                 output wire      [3:0]  HPS_ENET_TX_DATA,
                 output wire             HPS_ENET_TX_EN,
                 inout wire       [3:0]  HPS_FLASH_DATA,
                 output wire             HPS_FLASH_DCLK,
                 output wire             HPS_FLASH_NCSO,
                 inout wire              HPS_GSENSOR_INT,
                 inout wire              HPS_I2C1_SCLK,
                 inout wire              HPS_I2C1_SDAT,
                 inout wire              HPS_I2C2_SCLK,
                 inout wire              HPS_I2C2_SDAT,
                 inout wire              HPS_I2C_CONTROL,
                 inout wire              HPS_KEY,
                 inout wire              HPS_LED,
                 inout wire              HPS_LTC_GPIO,
                 output wire             HPS_SD_CLK,
                 inout wire              HPS_SD_CMD,
                 inout wire       [3:0]  HPS_SD_DATA,
                 output wire             HPS_SPIM_CLK,
                 input wire              HPS_SPIM_MISO,
                 output wire             HPS_SPIM_MOSI,
                 inout wire              HPS_SPIM_SS,
                 input wire              HPS_UART_RX,
                 output wire             HPS_UART_TX,
                 input wire              HPS_USB_CLKOUT,
                 inout wire       [7:0]  HPS_USB_DATA,
                 input wire              HPS_USB_DIR,
                 input wire              HPS_USB_NXT,
                 output wire             HPS_USB_STP
             );

// Aligning word address coming from avalon to byte address
logic [31:0] avalon_adr;
assign wshb_ifm.adr = avalon_adr << 1 ;

// Instantiate the generated hps from Qsys
hps  u0 (
        //HPS ddr3
        .memory_mem_a                          ( HPS_DDR3_ADDR),     //  memory.mem_a
        .memory_mem_ba                         ( HPS_DDR3_BA),       //        .mem_ba
        .memory_mem_ck                         ( HPS_DDR3_CK_P),     //        .mem_ck
        .memory_mem_ck_n                       ( HPS_DDR3_CK_N),     //        .mem_ck_n
        .memory_mem_cke                        ( HPS_DDR3_CKE),      //        .mem_cke
        .memory_mem_cs_n                       ( HPS_DDR3_CS_N),     //        .mem_cs_n
        .memory_mem_ras_n                      ( HPS_DDR3_RAS_N),    //        .mem_ras_n
        .memory_mem_cas_n                      ( HPS_DDR3_CAS_N),    //        .mem_cas_n
        .memory_mem_we_n                       ( HPS_DDR3_WE_N),     //        .mem_we_n
        .memory_mem_reset_n                    ( HPS_DDR3_RESET_N),  //        .mem_reset_n
        .memory_mem_dq                         ( HPS_DDR3_DQ),       //        .mem_dq
        .memory_mem_dqs                        ( HPS_DDR3_DQS_P),    //        .mem_dqs
        .memory_mem_dqs_n                      ( HPS_DDR3_DQS_N),    //        .mem_dqs_n
        .memory_mem_odt                        ( HPS_DDR3_ODT),      //        .mem_odt
        .memory_mem_dm                         ( HPS_DDR3_DM),       //        .mem_dm
        .memory_oct_rzqin                      ( HPS_DDR3_RZQ),      //        .oct_rzqin
       //HPS ethernet           
        .hps_0_hps_io_hps_io_emac1_inst_TX_CLK ( HPS_ENET_GTX_CLK),          //  hps_0_hps_io.hps_io_emac1_inst_TX_CLK
        .hps_0_hps_io_hps_io_emac1_inst_TXD0   ( HPS_ENET_TX_DATA[0] ),      //              .hps_io_emac1_inst_TXD0
        .hps_0_hps_io_hps_io_emac1_inst_TXD1   ( HPS_ENET_TX_DATA[1] ),      //              .hps_io_emac1_inst_TXD1
        .hps_0_hps_io_hps_io_emac1_inst_TXD2   ( HPS_ENET_TX_DATA[2] ),      //              .hps_io_emac1_inst_TXD2
        .hps_0_hps_io_hps_io_emac1_inst_TXD3   ( HPS_ENET_TX_DATA[3] ),      //              .hps_io_emac1_inst_TXD3
        .hps_0_hps_io_hps_io_emac1_inst_MDIO   ( HPS_ENET_MDIO ),            //              .hps_io_emac1_inst_MDIO
        .hps_0_hps_io_hps_io_emac1_inst_MDC    ( HPS_ENET_MDC  ),            //              .hps_io_emac1_inst_MDC
        .hps_0_hps_io_hps_io_emac1_inst_RX_CTL ( HPS_ENET_RX_DV),            //              .hps_io_emac1_inst_RX_CTL
        .hps_0_hps_io_hps_io_emac1_inst_TX_CTL ( HPS_ENET_TX_EN),            //              .hps_io_emac1_inst_TX_CTL
        .hps_0_hps_io_hps_io_emac1_inst_RX_CLK ( HPS_ENET_RX_CLK),           //              .hps_io_emac1_inst_RX_CLK
        .hps_0_hps_io_hps_io_emac1_inst_RXD0   ( HPS_ENET_RX_DATA[0] ),      //              .hps_io_emac1_inst_RXD0
        .hps_0_hps_io_hps_io_emac1_inst_RXD1   ( HPS_ENET_RX_DATA[1] ),      //              .hps_io_emac1_inst_RXD1
        .hps_0_hps_io_hps_io_emac1_inst_RXD2   ( HPS_ENET_RX_DATA[2] ),      //              .hps_io_emac1_inst_RXD2
        .hps_0_hps_io_hps_io_emac1_inst_RXD3   ( HPS_ENET_RX_DATA[3] ),      //              .hps_io_emac1_inst_RXD3
       //HPS QSPI  
        .hps_0_hps_io_hps_io_qspi_inst_IO0     ( HPS_FLASH_DATA[0]    ),     //                               .hps_io_qspi_inst_IO0
        .hps_0_hps_io_hps_io_qspi_inst_IO1     ( HPS_FLASH_DATA[1]    ),     //                               .hps_io_qspi_inst_IO1
        .hps_0_hps_io_hps_io_qspi_inst_IO2     ( HPS_FLASH_DATA[2]    ),     //                               .hps_io_qspi_inst_IO2
        .hps_0_hps_io_hps_io_qspi_inst_IO3     ( HPS_FLASH_DATA[3]    ),     //                               .hps_io_qspi_inst_IO3
        .hps_0_hps_io_hps_io_qspi_inst_SS0     ( HPS_FLASH_NCSO    ),        //                               .hps_io_qspi_inst_SS0
        .hps_0_hps_io_hps_io_qspi_inst_CLK     ( HPS_FLASH_DCLK    ),        //                               .hps_io_qspi_inst_CLK
       //HPS SD card 
        .hps_0_hps_io_hps_io_sdio_inst_CMD     ( HPS_SD_CMD    ),           //                               .hps_io_sdio_inst_CMD
        .hps_0_hps_io_hps_io_sdio_inst_D0      ( HPS_SD_DATA[0]     ),      //                               .hps_io_sdio_inst_D0
        .hps_0_hps_io_hps_io_sdio_inst_D1      ( HPS_SD_DATA[1]     ),      //                               .hps_io_sdio_inst_D1
        .hps_0_hps_io_hps_io_sdio_inst_CLK     ( HPS_SD_CLK   ),            //                               .hps_io_sdio_inst_CLK
        .hps_0_hps_io_hps_io_sdio_inst_D2      ( HPS_SD_DATA[2]     ),      //                               .hps_io_sdio_inst_D2
        .hps_0_hps_io_hps_io_sdio_inst_D3      ( HPS_SD_DATA[3]     ),      //                               .hps_io_sdio_inst_D3
       //HPS USB                  
        .hps_0_hps_io_hps_io_usb1_inst_D0      ( HPS_USB_DATA[0]    ),      //                               .hps_io_usb1_inst_D0
        .hps_0_hps_io_hps_io_usb1_inst_D1      ( HPS_USB_DATA[1]    ),      //                               .hps_io_usb1_inst_D1
        .hps_0_hps_io_hps_io_usb1_inst_D2      ( HPS_USB_DATA[2]    ),      //                               .hps_io_usb1_inst_D2
        .hps_0_hps_io_hps_io_usb1_inst_D3      ( HPS_USB_DATA[3]    ),      //                               .hps_io_usb1_inst_D3
        .hps_0_hps_io_hps_io_usb1_inst_D4      ( HPS_USB_DATA[4]    ),      //                               .hps_io_usb1_inst_D4
        .hps_0_hps_io_hps_io_usb1_inst_D5      ( HPS_USB_DATA[5]    ),      //                               .hps_io_usb1_inst_D5
        .hps_0_hps_io_hps_io_usb1_inst_D6      ( HPS_USB_DATA[6]    ),      //                               .hps_io_usb1_inst_D6
        .hps_0_hps_io_hps_io_usb1_inst_D7      ( HPS_USB_DATA[7]    ),      //                               .hps_io_usb1_inst_D7
        .hps_0_hps_io_hps_io_usb1_inst_CLK     ( HPS_USB_CLKOUT    ),       //                               .hps_io_usb1_inst_CLK
        .hps_0_hps_io_hps_io_usb1_inst_STP     ( HPS_USB_STP    ),          //                               .hps_io_usb1_inst_STP
        .hps_0_hps_io_hps_io_usb1_inst_DIR     ( HPS_USB_DIR    ),          //                               .hps_io_usb1_inst_DIR
        .hps_0_hps_io_hps_io_usb1_inst_NXT     ( HPS_USB_NXT    ),          //                               .hps_io_usb1_inst_NXT
       //HPS SPI                  
        .hps_0_hps_io_hps_io_spim1_inst_CLK    ( HPS_SPIM_CLK  ),           //                               .hps_io_spim1_inst_CLK
        .hps_0_hps_io_hps_io_spim1_inst_MOSI   ( HPS_SPIM_MOSI ),           //                               .hps_io_spim1_inst_MOSI
        .hps_0_hps_io_hps_io_spim1_inst_MISO   ( HPS_SPIM_MISO ),           //                               .hps_io_spim1_inst_MISO
       .hps_0_hps_io_hps_io_spim1_inst_SS0     ( HPS_SPIM_SS ),             //                               .hps_io_spim1_inst_SS0
      //HPS UART                
        .hps_0_hps_io_hps_io_uart0_inst_RX     ( HPS_UART_RX    ),          //                               .hps_io_uart0_inst_RX
        .hps_0_hps_io_hps_io_uart0_inst_TX     ( HPS_UART_TX    ),          //                               .hps_io_uart0_inst_TX
      //HPS I2C1
        .hps_0_hps_io_hps_io_i2c0_inst_SDA     ( HPS_I2C1_SDAT    ),        //                               .hps_io_i2c0_inst_SDA
        .hps_0_hps_io_hps_io_i2c0_inst_SCL     ( HPS_I2C1_SCLK    ),        //                               .hps_io_i2c0_inst_SCL
       //HPS I2C2
        .hps_0_hps_io_hps_io_i2c1_inst_SDA     ( HPS_I2C2_SDAT    ),        //                               .hps_io_i2c1_inst_SDA
        .hps_0_hps_io_hps_io_i2c1_inst_SCL     ( HPS_I2C2_SCLK    ),        //                               .hps_io_i2c1_inst_SCL
      //HPS GPIO  
        .hps_0_hps_io_hps_io_gpio_inst_GPIO09  ( HPS_CONV_USB_N),           //                               .hps_io_gpio_inst_GPIO09
        .hps_0_hps_io_hps_io_gpio_inst_GPIO35  ( HPS_ENET_INT_N),           //                               .hps_io_gpio_inst_GPIO35
        .hps_0_hps_io_hps_io_gpio_inst_GPIO40  ( HPS_LTC_GPIO),             //                               .hps_io_gpio_inst_GPIO40
        .hps_0_hps_io_hps_io_gpio_inst_GPIO48  ( HPS_I2C_CONTROL),          //                               .hps_io_gpio_inst_GPIO48
        .hps_0_hps_io_hps_io_gpio_inst_GPIO53  ( HPS_LED),                  //                               .hps_io_gpio_inst_GPIO53
        .hps_0_hps_io_hps_io_gpio_inst_GPIO54  ( HPS_KEY),                  //                               .hps_io_gpio_inst_GPIO54
        .hps_0_hps_io_hps_io_gpio_inst_GPIO61  ( HPS_GSENSOR_INT),          //                               .hps_io_gpio_inst_GPIO61
      // Wishbone part
        .clk_clk                               (wshb_ifm.clk),                      //                clk.clk
        .reset_reset_n                         (1'b1),                              //                reset.reset_n
        .wishbone_dat_i                        (wshb_ifm.dat_sm),                   //                wishbone.dat_i
        .wishbone_rst_i                        (),                                  //                .rst_i
        .wishbone_tgd_i                        (),                                  //                .tgd_i
        .wishbone_dat_o                        (wshb_ifm.dat_ms),                   //                .dat_o
        .wishbone_tgd_o                        (),                                  //                .tgd_o
        .wishbone_ack                          (wshb_ifm.ack),                      //                .ack
        .wishbone_adr                          (avalon_adr),                        //                .adr
        .wishbone_cyc                          (wshb_ifm.cyc),                      //                .cyc
        .wishbone_lock                         (),                                  //                .lock
        .wishbone_rty                          (wshb_ifm.rty),                      //                 .rty
        .wishbone_sel                          (wshb_ifm.sel),                      //                 .sel
        .wishbone_stb                          (wshb_ifm.stb),                      //                 .stb
        .wishbone_tga                          (),                                  //                 .tga
        .wishbone_tgc                          (),                                  //                 .tgc
        .wishbone_we                           (wshb_ifm.we)                        //                 .we
    ) ;
        

endmodule
