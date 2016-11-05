// HPS IOs 
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
output wire             HPS_USB_STP,