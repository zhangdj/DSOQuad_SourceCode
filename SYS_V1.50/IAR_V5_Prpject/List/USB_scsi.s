///////////////////////////////////////////////////////////////////////////////
//                                                                            /
//                                                      09/Aug/2011  14:03:47 /
// IAR ANSI C/C++ Compiler V5.20.0.20892/W32 EVALUATION for ARM               /
// Copyright 1999-2008 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  E:\Mini-DS\DS203\SYS_V1.50\source\USB_scsi.c            /
//    Command line =  E:\Mini-DS\DS203\SYS_V1.50\source\USB_scsi.c -lA        /
//                    E:\Mini-DS\DS203\SYS_V1.50\IAR_V5_Prpject\List\ -o      /
//                    E:\Mini-DS\DS203\SYS_V1.50\IAR_V5_Prpject\Obj\          /
//                    --no_inline --endian=little --cpu=Cortex-M3 -e          /
//                    --fpu=None --dlib_config "C:\Program Files\IAR          /
//                    Systems\Embedded Workbench 5.0                          /
//                    Evaluation\ARM\INC\DLib_Config_Normal.h" -I             /
//                    E:\Mini-DS\DS203\SYS_V1.50\IAR_V5_Prpject\..\..\FWLib\i /
//                    nc\ -I E:\Mini-DS\DS203\SYS_V1.50\IAR_V5_Prpject\..\..\ /
//                    USBLib\inc\ -I E:\Mini-DS\DS203\SYS_V1.50\IAR_V5_Prpjec /
//                    t\..\include\ -I "C:\Program Files\IAR                  /
//                    Systems\Embedded Workbench 5.0 Evaluation\ARM\INC\"     /
//                    -Ohs                                                    /
//    List file    =  E:\Mini-DS\DS203\SYS_V1.50\IAR_V5_Prpject\List\USB_scsi /
//                    .s                                                      /
//                                                                            /
//                                                                            /
///////////////////////////////////////////////////////////////////////////////

        NAME USB_scsi

        EXTERN Bot_Abort
        EXTERN Bot_State
        EXTERN CBW
        EXTERN MAL_GetStatus
        EXTERN Mass_Block_Count
        EXTERN Mass_Block_Size
        EXTERN Mode_Sense10_data
        EXTERN Mode_Sense6_data
        EXTERN Page00_Inquiry_Data
        EXTERN ReadCapacity10_Data
        EXTERN ReadFormatCapacity_Data
        EXTERN Read_Memory
        EXTERN Scsi_Sense_Data
        EXTERN SetEPRxStatus
        EXTERN Set_CSW
        EXTERN Standard_Inquiry_Data
        EXTERN Transfer_Data_Request
        EXTERN Write_Memory

        PUBLIC SCSI_Address_Management
        PUBLIC SCSI_Format_Cmd
        PUBLIC SCSI_Inquiry_Cmd
        PUBLIC SCSI_Invalid_Cmd
        PUBLIC SCSI_ModeSense10_Cmd
        PUBLIC SCSI_ModeSense6_Cmd
        PUBLIC SCSI_Read10_Cmd
        PUBLIC SCSI_ReadCapacity10_Cmd
        PUBLIC SCSI_ReadFormatCapacity_Cmd
        PUBLIC SCSI_RequestSense_Cmd
        PUBLIC SCSI_Start_Stop_Unit_Cmd
        PUBLIC SCSI_TestUnitReady_Cmd
        PUBLIC SCSI_Valid_Cmd
        PUBLIC SCSI_Verify10_Cmd
        PUBLIC SCSI_Write10_Cmd
        PUBLIC Set_Scsi_Sense_Data
        
        CFI Names cfiNames0
        CFI StackFrame CFA R13 DATA
        CFI Resource R0:32, R1:32, R2:32, R3:32, R4:32, R5:32, R6:32, R7:32
        CFI Resource R8:32, R9:32, R10:32, R11:32, R12:32, R13:32, R14:32
        CFI EndNames cfiNames0
        
        CFI Common cfiCommon0 Using cfiNames0
        CFI CodeAlign 2
        CFI DataAlign 4
        CFI ReturnAddress R14 CODE
        CFI CFA R13+0
        CFI R0 Undefined
        CFI R1 Undefined
        CFI R2 Undefined
        CFI R3 Undefined
        CFI R4 SameValue
        CFI R5 SameValue
        CFI R6 SameValue
        CFI R7 SameValue
        CFI R8 SameValue
        CFI R9 SameValue
        CFI R10 SameValue
        CFI R11 SameValue
        CFI R12 Undefined
        CFI R14 SameValue
        CFI EndCommon cfiCommon0
        
// E:\Mini-DS\DS203\SYS_V1.50\source\USB_scsi.c
//    1 /******************** (C) COPYRIGHT 2008 STMicroelectronics ********************
//    2 * File Name          : usb_scsi.c
//    3 * Author             : MCD Application Team
//    4 * Version            : V2.2.1
//    5 * Date               : 09/22/2008
//    6 * Description        : All processing related to the SCSI commands
//    7 ********************************************************************************
//    8 * THE PRESENT FIRMWARE WHICH IS FOR GUIDANCE ONLY AIMS AT PROVIDING CUSTOMERS
//    9 * WITH CODING INFORMATION REGARDING THEIR PRODUCTS IN ORDER FOR THEM TO SAVE TIME.
//   10 * AS A RESULT, STMICROELECTRONICS SHALL NOT BE HELD LIABLE FOR ANY DIRECT,
//   11 * INDIRECT OR CONSEQUENTIAL DAMAGES WITH RESPECT TO ANY CLAIMS ARISING FROM THE
//   12 * CONTENT OF SUCH FIRMWARE AND/OR THE USE MADE BY CUSTOMERS OF THE CODING
//   13 * INFORMATION CONTAINED HEREIN IN CONNECTION WITH THEIR PRODUCTS.
//   14 *******************************************************************************/
//   15 
//   16 /* Includes ------------------------------------------------------------------*/
//   17 #include "Config.h"
//   18 #include "USB_scsi.h"
//   19 #include "USB_bot.h"
//   20 #include "USB_regs.h"
//   21 #include "Ext_Flash.h"
//   22 #include "Memory.h"
//   23 
//   24 /* Private typedef -----------------------------------------------------------*/
//   25 /* Private define ------------------------------------------------------------*/
//   26 /* Private macro -------------------------------------------------------------*/
//   27 /* Private variables ---------------------------------------------------------*/
//   28 /* External variables --------------------------------------------------------*/
//   29 extern u8 Bulk_Data_Buff[BULK_MAX_PACKET_SIZE];  /* data buffer*/
//   30 extern u8 Bot_State;
//   31 extern Bulk_Only_CBW CBW;
//   32 extern Bulk_Only_CSW CSW;
//   33 extern u32 Mass_Memory_Size;
//   34 extern u32 Mass_Block_Size;
//   35 extern u32 Mass_Block_Count;
//   36 
//   37 /* Private function prototypes -----------------------------------------------*/
//   38 /* Private functions ---------------------------------------------------------*/
//   39 
//   40 /*******************************************************************************
//   41 * Function Name  : SCSI_Inquiry_Cmd
//   42 * Description    : SCSI Inquiry Command routine.
//   43 * Input          : None.
//   44 * Output         : None.
//   45 * Return         : None.
//   46 *******************************************************************************/

        SECTION `.text`:CODE:NOROOT(2)
        CFI Block cfiBlock0 Using cfiCommon0
        CFI Function SCSI_Inquiry_Cmd
        THUMB
//   47 void SCSI_Inquiry_Cmd(void)
//   48 {
//   49   u8* Inquiry_Data;
//   50   u16 Inquiry_Data_Length;
//   51 
//   52   if (CBW.CB[1] & 0x01)/*Evpd is set*/
SCSI_Inquiry_Cmd:
        LDR.N    R1,??DataTable16  ;; CBW
        LDRB     R0,[R1, #+16]
        TST      R0,#0x1
        BEQ.N    ??SCSI_Inquiry_Cmd_0
//   53   {
//   54     Inquiry_Data = Page00_Inquiry_Data;
        LDR.N    R0,??SCSI_Inquiry_Cmd_1  ;; Page00_Inquiry_Data
//   55     Inquiry_Data_Length = 5;
        MOVS     R1,#+5
        B.N      ??SCSI_Inquiry_Cmd_2
//   56   }
//   57   else
//   58   {
//   59 
//   60 //    if ( lun == 0)
//   61 //    {
//   62       Inquiry_Data = Standard_Inquiry_Data;
??SCSI_Inquiry_Cmd_0:
        LDR.N    R0,??SCSI_Inquiry_Cmd_1+0x4  ;; Standard_Inquiry_Data
//   63 //    }
//   64 //    else
//   65 //    {
//   66 //      Inquiry_Data = Standard_Inquiry_Data2;
//   67 //    }
//   68 //
//   69     if (CBW.CB[4] <= STANDARD_INQUIRY_DATA_LEN)
        LDRB     R1,[R1, #+19]
        CMP      R1,#+37
        IT       CS 
//   70       Inquiry_Data_Length = CBW.CB[4];
//   71     else
//   72       Inquiry_Data_Length = STANDARD_INQUIRY_DATA_LEN;
        MOVCS    R1,#+36
//   73 
//   74   }
//   75   Transfer_Data_Request(Inquiry_Data, Inquiry_Data_Length);
??SCSI_Inquiry_Cmd_2:
        B.W      Transfer_Data_Request
        Nop      
        DATA
??SCSI_Inquiry_Cmd_1:
        DC32     Page00_Inquiry_Data
        DC32     Standard_Inquiry_Data
        CFI EndBlock cfiBlock0
//   76 }
//   77 
//   78 /*******************************************************************************
//   79 * Function Name  : SCSI_ReadFormatCapacity_Cmd
//   80 * Description    : SCSI ReadFormatCapacity Command routine.
//   81 * Input          : None.
//   82 * Output         : None.
//   83 * Return         : None.
//   84 *******************************************************************************/

        SECTION `.text`:CODE:NOROOT(2)
        CFI Block cfiBlock1 Using cfiCommon0
        CFI Function SCSI_ReadFormatCapacity_Cmd
        THUMB
//   85 void SCSI_ReadFormatCapacity_Cmd(void)
//   86 {
SCSI_ReadFormatCapacity_Cmd:
        PUSH     {LR}
        CFI R14 Frame(CFA, -4)
        CFI CFA R13+4
        SUB      SP,SP,#+4
        CFI CFA R13+8
//   87 
//   88   MAL_GetStatus();
        BL       MAL_GetStatus
//   89   ReadFormatCapacity_Data[4] = (u8)(Mass_Block_Count >> 24);
        LDR.N    R0,??DataTable15  ;; Mass_Block_Count
        LDR      R1,[R0, #+0]
        LDR.N    R0,??SCSI_ReadFormatCapacity_Cmd_0  ;; ReadFormatCapacity_Data
        LSRS     R2,R1,#+24
        STRB     R2,[R0, #+4]
//   90   ReadFormatCapacity_Data[5] = (u8)(Mass_Block_Count >> 16);
        LSRS     R2,R1,#+16
        STRB     R2,[R0, #+5]
//   91   ReadFormatCapacity_Data[6] = (u8)(Mass_Block_Count >>  8);
        LSRS     R2,R1,#+8
        STRB     R2,[R0, #+6]
//   92   ReadFormatCapacity_Data[7] = (u8)(Mass_Block_Count);
        STRB     R1,[R0, #+7]
//   93 
//   94   ReadFormatCapacity_Data[9] = (u8)(Mass_Block_Size >>  16);
        LDR.N    R1,??DataTable17  ;; Mass_Block_Size
        LDR      R1,[R1, #+0]
        LSRS     R2,R1,#+16
        STRB     R2,[R0, #+9]
//   95   ReadFormatCapacity_Data[10] = (u8)(Mass_Block_Size >>  8);
        LSRS     R2,R1,#+8
        STRB     R2,[R0, #+10]
//   96   ReadFormatCapacity_Data[11] = (u8)(Mass_Block_Size);
        STRB     R1,[R0, #+11]
//   97   Transfer_Data_Request(ReadFormatCapacity_Data, READ_FORMAT_CAPACITY_DATA_LEN);
        MOVS     R1,#+12
        ADD      SP,SP,#+4
        CFI CFA R13+4
        POP      {LR}
        CFI R14 SameValue
        CFI CFA R13+0
        B.W      Transfer_Data_Request
        Nop      
        DATA
??SCSI_ReadFormatCapacity_Cmd_0:
        DC32     ReadFormatCapacity_Data
        CFI EndBlock cfiBlock1
//   98 }
//   99 
//  100 /*******************************************************************************
//  101 * Function Name  : SCSI_ReadCapacity10_Cmd
//  102 * Description    : SCSI ReadCapacity10 Command routine.
//  103 * Input          : None.
//  104 * Output         : None.
//  105 * Return         : None.
//  106 *******************************************************************************/

        SECTION `.text`:CODE:NOROOT(2)
        CFI Block cfiBlock2 Using cfiCommon0
        CFI Function SCSI_ReadCapacity10_Cmd
        THUMB
//  107 void SCSI_ReadCapacity10_Cmd(void)
//  108 {
SCSI_ReadCapacity10_Cmd:
        PUSH     {LR}
        CFI R14 Frame(CFA, -4)
        CFI CFA R13+4
        SUB      SP,SP,#+4
        CFI CFA R13+8
//  109 
//  110   MAL_GetStatus();
        BL       MAL_GetStatus
//  111   ReadCapacity10_Data[0] = (u8)(Mass_Block_Count - 1 >> 24);
        LDR.N    R0,??DataTable15  ;; Mass_Block_Count
        LDR      R1,[R0, #+0]
        SUBS     R2,R1,#+1
        LDR.N    R0,??SCSI_ReadCapacity10_Cmd_0  ;; ReadCapacity10_Data
        LSRS     R3,R2,#+24
        STRB     R3,[R0, #+0]
//  112   ReadCapacity10_Data[1] = (u8)(Mass_Block_Count - 1 >> 16);
        LSRS     R3,R2,#+16
        STRB     R3,[R0, #+1]
//  113   ReadCapacity10_Data[2] = (u8)(Mass_Block_Count - 1 >>  8);
        LSRS     R2,R2,#+8
        STRB     R2,[R0, #+2]
//  114   ReadCapacity10_Data[3] = (u8)(Mass_Block_Count - 1);
        SUBS     R1,R1,#+1
        STRB     R1,[R0, #+3]
//  115 
//  116   ReadCapacity10_Data[4] = (u8)(Mass_Block_Size >>  24);
        LDR.N    R1,??DataTable17  ;; Mass_Block_Size
        LDR      R1,[R1, #+0]
        LSRS     R2,R1,#+24
        STRB     R2,[R0, #+4]
//  117   ReadCapacity10_Data[5] = (u8)(Mass_Block_Size >>  16);
        LSRS     R2,R1,#+16
        STRB     R2,[R0, #+5]
//  118   ReadCapacity10_Data[6] = (u8)(Mass_Block_Size >>  8);
        LSRS     R2,R1,#+8
        STRB     R2,[R0, #+6]
//  119   ReadCapacity10_Data[7] = (u8)(Mass_Block_Size);
        STRB     R1,[R0, #+7]
//  120   Transfer_Data_Request(ReadCapacity10_Data, READ_CAPACITY10_DATA_LEN);
        MOVS     R1,#+8
        ADD      SP,SP,#+4
        CFI CFA R13+4
        POP      {LR}
        CFI R14 SameValue
        CFI CFA R13+0
        B.W      Transfer_Data_Request
        Nop      
        DATA
??SCSI_ReadCapacity10_Cmd_0:
        DC32     ReadCapacity10_Data
        CFI EndBlock cfiBlock2
//  121 }
//  122 
//  123 /*******************************************************************************
//  124 * Function Name  : SCSI_ModeSense6_Cmd
//  125 * Description    : SCSI ModeSense6 Command routine.
//  126 * Input          : None.
//  127 * Output         : None.
//  128 * Return         : None.
//  129 *******************************************************************************/

        SECTION `.text`:CODE:NOROOT(2)
        CFI Block cfiBlock3 Using cfiCommon0
        CFI Function SCSI_ModeSense6_Cmd
        THUMB
//  130 void SCSI_ModeSense6_Cmd (void)
//  131 {
//  132   Transfer_Data_Request(Mode_Sense6_data, MODE_SENSE6_DATA_LEN);
SCSI_ModeSense6_Cmd:
        MOVS     R1,#+4
        LDR.N    R0,??SCSI_ModeSense6_Cmd_0  ;; Mode_Sense6_data
        B.W      Transfer_Data_Request
        DATA
??SCSI_ModeSense6_Cmd_0:
        DC32     Mode_Sense6_data
        CFI EndBlock cfiBlock3
//  133 }
//  134 
//  135 /*******************************************************************************
//  136 * Function Name  : SCSI_ModeSense10_Cmd
//  137 * Description    : SCSI ModeSense10 Command routine.
//  138 * Input          : None.
//  139 * Output         : None.
//  140 * Return         : None.
//  141 *******************************************************************************/

        SECTION `.text`:CODE:NOROOT(2)
        CFI Block cfiBlock4 Using cfiCommon0
        CFI Function SCSI_ModeSense10_Cmd
        THUMB
//  142 void SCSI_ModeSense10_Cmd (void)
//  143 {
//  144   Transfer_Data_Request(Mode_Sense10_data, MODE_SENSE10_DATA_LEN);
SCSI_ModeSense10_Cmd:
        MOVS     R1,#+8
        LDR.N    R0,??SCSI_ModeSense10_Cmd_0  ;; Mode_Sense10_data
        B.W      Transfer_Data_Request
        DATA
??SCSI_ModeSense10_Cmd_0:
        DC32     Mode_Sense10_data
        CFI EndBlock cfiBlock4
//  145 }
//  146 
//  147 /*******************************************************************************
//  148 * Function Name  : SCSI_RequestSense_Cmd
//  149 * Description    : SCSI RequestSense Command routine.
//  150 * Input          : None.
//  151 * Output         : None.
//  152 * Return         : None.
//  153 *******************************************************************************/

        SECTION `.text`:CODE:NOROOT(2)
        CFI Block cfiBlock5 Using cfiCommon0
        CFI Function SCSI_RequestSense_Cmd
        THUMB
//  154 void SCSI_RequestSense_Cmd (void)
//  155 {
SCSI_RequestSense_Cmd:
        LDR.N    R0,??DataTable16  ;; CBW
        LDRB     R1,[R0, #+19]
        CMP      R1,#+19
        IT       CS 
//  156   u8 Request_Sense_data_Length;
//  157 
//  158   if (CBW.CB[4] <= REQUEST_SENSE_DATA_LEN)
//  159   {
//  160     Request_Sense_data_Length = CBW.CB[4];
//  161   }
//  162   else
//  163   {
//  164     Request_Sense_data_Length = REQUEST_SENSE_DATA_LEN;
        MOVCS    R1,#+18
//  165   }
//  166   Transfer_Data_Request(Scsi_Sense_Data, Request_Sense_data_Length);
        LDR.N    R0,??DataTable7  ;; Scsi_Sense_Data
        B.W      Transfer_Data_Request
        CFI EndBlock cfiBlock5
//  167 }
//  168 
//  169 /*******************************************************************************
//  170 * Function Name  : Set_Scsi_Sense_Data
//  171 * Description    : Set Scsi Sense Data routine.
//  172 * Input          : u8 Sens_Key
//  173                    u8 Asc.
//  174 * Output         : None.
//  175 * Return         : None.
//  176 *******************************************************************************/

        SECTION `.text`:CODE:NOROOT(2)
        CFI Block cfiBlock6 Using cfiCommon0
        CFI Function Set_Scsi_Sense_Data
        THUMB
//  177 void Set_Scsi_Sense_Data(u8 Sens_Key, u8 Asc)
//  178 {
//  179   Scsi_Sense_Data[2] = Sens_Key;
Set_Scsi_Sense_Data:
        LDR.N    R2,??DataTable7  ;; Scsi_Sense_Data
        STRB     R0,[R2, #+2]
//  180   Scsi_Sense_Data[12] = Asc;
        STRB     R1,[R2, #+12]
//  181 }
        BX       LR               ;; return
        CFI EndBlock cfiBlock6

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable7:
        DC32     Scsi_Sense_Data
//  182 
//  183 /*******************************************************************************
//  184 * Function Name  : SCSI_Start_Stop_Unit_Cmd
//  185 * Description    : SCSI Start_Stop_Unit Command routine.
//  186 * Input          : None.
//  187 * Output         : None.
//  188 * Return         : None.
//  189 *******************************************************************************/

        SECTION `.text`:CODE:NOROOT(2)
        CFI Block cfiBlock7 Using cfiCommon0
        CFI Function SCSI_Start_Stop_Unit_Cmd
        THUMB
//  190 void SCSI_Start_Stop_Unit_Cmd(void)
//  191 {
//  192   Set_CSW (CSW_CMD_PASSED, SEND_CSW_ENABLE);
SCSI_Start_Stop_Unit_Cmd:
        MOVS     R1,#+1
        MOVS     R0,#+0
        B.W      Set_CSW
        CFI EndBlock cfiBlock7
//  193 }
//  194 
//  195 /*******************************************************************************
//  196 * Function Name  : SCSI_Read10_Cmd
//  197 * Description    : SCSI Read10 Command routine.
//  198 * Input          : None.
//  199 * Output         : None.
//  200 * Return         : None.
//  201 *******************************************************************************/

        SECTION `.text`:CODE:NOROOT(2)
        CFI Block cfiBlock8 Using cfiCommon0
        CFI Function SCSI_Read10_Cmd
        THUMB
//  202 void SCSI_Read10_Cmd(u32 LBA , u32 BlockNbr)
//  203 {
SCSI_Read10_Cmd:
        PUSH     {R4-R6,LR}
        CFI R14 Frame(CFA, -4)
        CFI R6 Frame(CFA, -8)
        CFI R5 Frame(CFA, -12)
        CFI R4 Frame(CFA, -16)
        CFI CFA R13+16
        MOVS     R5,R0
        MOVS     R4,R1
//  204 
//  205   if (Bot_State == BOT_IDLE)
        LDR.N    R6,??DataTable10  ;; Bot_State
        LDRB     R0,[R6, #+0]
        CBNZ     R0,??SCSI_Read10_Cmd_0
//  206   {
//  207     if (!(SCSI_Address_Management(SCSI_READ10, LBA, BlockNbr)))/*address out of range*/
        MOVS     R2,R4
        MOVS     R1,R5
        MOVS     R0,#+40
        BL       SCSI_Address_Management
        CBZ      R0,??SCSI_Read10_Cmd_1
//  208     {
//  209       return;
//  210     }
//  211 
//  212     if ((CBW.bmFlags & 0x80) != 0)
        LDR.N    R0,??DataTable16  ;; CBW
        LDRB     R0,[R0, #+12]
        TST      R0,#0x80
        BEQ.N    ??SCSI_Read10_Cmd_2
//  213     {
//  214       Bot_State = BOT_DATA_IN;
        MOVS     R0,#+2
        STRB     R0,[R6, #+0]
//  215       Read_Memory(LBA , BlockNbr);
        MOVS     R1,R4
        B.N      ??SCSI_Read10_Cmd_3
//  216     }
//  217     else
//  218     {
//  219       Bot_Abort(BOTH_DIR);
??SCSI_Read10_Cmd_2:
        MOVS     R0,#+2
        BL       Bot_Abort
//  220       Set_Scsi_Sense_Data(ILLEGAL_REQUEST, INVALID_FIELED_IN_COMMAND);
        MOVS     R1,#+36
        MOVS     R0,#+5
        BL       Set_Scsi_Sense_Data
//  221       Set_CSW (CSW_CMD_FAILED, SEND_CSW_ENABLE);
        MOVS     R1,#+1
        MOVS     R0,#+1
        BL       Set_CSW
        POP      {R4-R6,PC}
//  222     }
//  223     return;
//  224   }
//  225   else if (Bot_State == BOT_DATA_IN)
??SCSI_Read10_Cmd_0:
        CMP      R0,#+2
        BNE.N    ??SCSI_Read10_Cmd_1
//  226   {
//  227     Read_Memory(LBA , BlockNbr);
??SCSI_Read10_Cmd_3:
        MOVS     R0,R5
        BL       Read_Memory
??SCSI_Read10_Cmd_1:
        POP      {R4-R6,PC}       ;; return
        CFI EndBlock cfiBlock8
//  228   }
//  229 }
//  230 
//  231 /*******************************************************************************
//  232 * Function Name  : SCSI_Write10_Cmd
//  233 * Description    : SCSI Write10 Command routine.
//  234 * Input          : None.
//  235 * Output         : None.
//  236 * Return         : None.
//  237 *******************************************************************************/

        SECTION `.text`:CODE:NOROOT(2)
        CFI Block cfiBlock9 Using cfiCommon0
        CFI Function SCSI_Write10_Cmd
        THUMB
//  238 void SCSI_Write10_Cmd(u32 LBA , u32 BlockNbr)
//  239 {
SCSI_Write10_Cmd:
        PUSH     {R4,LR}
        CFI R14 Frame(CFA, -4)
        CFI R4 Frame(CFA, -8)
        CFI CFA R13+8
//  240 
//  241   if (Bot_State == BOT_IDLE)
        LDR.N    R4,??DataTable10  ;; Bot_State
        LDRB     R2,[R4, #+0]
        CBNZ     R2,??SCSI_Write10_Cmd_0
//  242   {
//  243     if (!(SCSI_Address_Management(SCSI_WRITE10 , LBA, BlockNbr)))/*address out of range*/
        MOVS     R2,R1
        MOVS     R1,R0
        MOVS     R0,#+42
        BL       SCSI_Address_Management
        CBZ      R0,??SCSI_Write10_Cmd_1
//  244     {
//  245       return;
//  246     }
//  247 
//  248     if ((CBW.bmFlags & 0x80) == 0)
        LDR.N    R0,??DataTable16  ;; CBW
        LDRB     R0,[R0, #+12]
        TST      R0,#0x80
        BNE.N    ??SCSI_Write10_Cmd_2
//  249     {
//  250       Bot_State = BOT_DATA_OUT;
        MOVS     R0,#+1
        STRB     R0,[R4, #+0]
//  251       SetEPRxStatus(ENDP2, EP_RX_VALID);
        MOV      R1,#+12288
        MOVS     R0,#+2
        BL       SetEPRxStatus
        POP      {R4,PC}
//  252     }
//  253     else
//  254     {
//  255       Bot_Abort(DIR_IN);
??SCSI_Write10_Cmd_2:
        MOVS     R0,#+0
        BL       Bot_Abort
//  256       Set_Scsi_Sense_Data(ILLEGAL_REQUEST, INVALID_FIELED_IN_COMMAND);
        MOVS     R1,#+36
        MOVS     R0,#+5
        BL       Set_Scsi_Sense_Data
//  257       Set_CSW (CSW_CMD_FAILED, SEND_CSW_DISABLE);
        MOVS     R1,#+0
        MOVS     R0,#+1
        BL       Set_CSW
        POP      {R4,PC}
//  258     }
//  259     return;
//  260   }
//  261   else if (Bot_State == BOT_DATA_OUT)
??SCSI_Write10_Cmd_0:
        CMP      R2,#+1
        IT       EQ 
//  262   {
//  263     Write_Memory(LBA , BlockNbr);
        BLEQ     Write_Memory
??SCSI_Write10_Cmd_1:
        POP      {R4,PC}          ;; return
        CFI EndBlock cfiBlock9
//  264   }
//  265 }

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable10:
        DC32     Bot_State
//  266 
//  267 /*******************************************************************************
//  268 * Function Name  : SCSI_Verify10_Cmd
//  269 * Description    : SCSI Verify10 Command routine.
//  270 * Input          : None.
//  271 * Output         : None.
//  272 * Return         : None.
//  273 *******************************************************************************/

        SECTION `.text`:CODE:NOROOT(2)
        CFI Block cfiBlock10 Using cfiCommon0
        CFI Function SCSI_Verify10_Cmd
        THUMB
//  274 void SCSI_Verify10_Cmd(void)
//  275 {
SCSI_Verify10_Cmd:
        PUSH     {LR}
        CFI R14 Frame(CFA, -4)
        CFI CFA R13+4
        SUB      SP,SP,#+4
        CFI CFA R13+8
//  276   if ((CBW.dDataLength == 0) && !(CBW.CB[1] & BLKVFY))/* BLKVFY not set*/
        LDR.N    R0,??DataTable16  ;; CBW
        LDR      R1,[R0, #+8]
        CBNZ     R1,??SCSI_Verify10_Cmd_0
        LDRB     R0,[R0, #+16]
        TST      R0,#0x4
        BNE.N    ??SCSI_Verify10_Cmd_0
//  277   {
//  278     Set_CSW (CSW_CMD_PASSED, SEND_CSW_ENABLE);
        MOVS     R1,#+1
        MOVS     R0,#+0
        B.N      ??SCSI_Verify10_Cmd_1
//  279   }
//  280   else
//  281   {
//  282     Bot_Abort(BOTH_DIR);
??SCSI_Verify10_Cmd_0:
        MOVS     R0,#+2
        BL       Bot_Abort
//  283     Set_Scsi_Sense_Data(ILLEGAL_REQUEST, INVALID_FIELED_IN_COMMAND);
        MOVS     R1,#+36
        MOVS     R0,#+5
        BL       Set_Scsi_Sense_Data
//  284     Set_CSW (CSW_CMD_FAILED, SEND_CSW_DISABLE);
        MOVS     R1,#+0
        MOVS     R0,#+1
??SCSI_Verify10_Cmd_1:
        BL       Set_CSW
//  285   }
//  286 }
        ADD      SP,SP,#+4
        CFI CFA R13+4
        POP      {PC}             ;; return
        CFI EndBlock cfiBlock10
//  287 /*******************************************************************************
//  288 * Function Name  : SCSI_Valid_Cmd
//  289 * Description    : Valid Commands routine.
//  290 * Input          : None.
//  291 * Output         : None.
//  292 * Return         : None.
//  293 *******************************************************************************/

        SECTION `.text`:CODE:NOROOT(2)
        CFI Block cfiBlock11 Using cfiCommon0
        CFI Function SCSI_Valid_Cmd
        THUMB
//  294 void SCSI_Valid_Cmd(void)
//  295 {
SCSI_Valid_Cmd:
        PUSH     {LR}
        CFI R14 Frame(CFA, -4)
        CFI CFA R13+4
        SUB      SP,SP,#+4
        CFI CFA R13+8
//  296   if (CBW.dDataLength != 0)
        LDR.N    R0,??DataTable16  ;; CBW
        LDR      R0,[R0, #+8]
        CBZ      R0,??SCSI_Valid_Cmd_0
//  297   {
//  298     Bot_Abort(BOTH_DIR);
        MOVS     R0,#+2
        BL       Bot_Abort
//  299     Set_Scsi_Sense_Data(ILLEGAL_REQUEST, INVALID_COMMAND);
        MOVS     R1,#+32
        MOVS     R0,#+5
        BL       Set_Scsi_Sense_Data
//  300     Set_CSW (CSW_CMD_FAILED, SEND_CSW_DISABLE);
        MOVS     R1,#+0
        MOVS     R0,#+1
        B.N      ??SCSI_Valid_Cmd_1
//  301   }
//  302   else
//  303     Set_CSW (CSW_CMD_PASSED, SEND_CSW_ENABLE);
??SCSI_Valid_Cmd_0:
        MOVS     R1,#+1
??SCSI_Valid_Cmd_1:
        BL       Set_CSW
//  304 }
        ADD      SP,SP,#+4
        CFI CFA R13+4
        POP      {PC}             ;; return
        CFI EndBlock cfiBlock11
//  305 /*******************************************************************************
//  306 * Function Name  : SCSI_Valid_Cmd
//  307 * Description    : Valid Commands routine.
//  308 * Input          : None.
//  309 * Output         : None.
//  310 * Return         : None.
//  311 *******************************************************************************/

        SECTION `.text`:CODE:NOROOT(2)
        CFI Block cfiBlock12 Using cfiCommon0
        CFI Function SCSI_TestUnitReady_Cmd
        THUMB
//  312 void SCSI_TestUnitReady_Cmd(void)
//  313 {
SCSI_TestUnitReady_Cmd:
        PUSH     {LR}
        CFI R14 Frame(CFA, -4)
        CFI CFA R13+4
        SUB      SP,SP,#+4
        CFI CFA R13+8
//  314   MAL_GetStatus();
        BL       MAL_GetStatus
//  315   Set_CSW (CSW_CMD_PASSED, SEND_CSW_ENABLE);
        MOVS     R1,#+1
        MOVS     R0,#+0
        ADD      SP,SP,#+4
        CFI CFA R13+4
        POP      {LR}
        CFI R14 SameValue
        CFI CFA R13+0
        B.W      Set_CSW
        CFI EndBlock cfiBlock12
//  316 }
//  317 /*******************************************************************************
//  318 * Function Name  : SCSI_Format_Cmd
//  319 * Description    : Format Commands routine.
//  320 * Input          : None.
//  321 * Output         : None.
//  322 * Return         : None.
//  323 *******************************************************************************/

        SECTION `.text`:CODE:NOROOT(2)
        CFI Block cfiBlock13 Using cfiCommon0
        CFI Function SCSI_Format_Cmd
        THUMB
//  324 void SCSI_Format_Cmd(void)
//  325 {
//  326   MAL_GetStatus();
SCSI_Format_Cmd:
        B.W      MAL_GetStatus
        CFI EndBlock cfiBlock13
//  327 }
//  328 /*******************************************************************************
//  329 * Function Name  : SCSI_Invalid_Cmd
//  330 * Description    : Invalid Commands routine
//  331 * Input          : None.
//  332 * Output         : None.
//  333 * Return         : None.
//  334 *******************************************************************************/

        SECTION `.text`:CODE:NOROOT(2)
        CFI Block cfiBlock14 Using cfiCommon0
        CFI Function SCSI_Invalid_Cmd
        THUMB
//  335 void SCSI_Invalid_Cmd(void)
//  336 {
SCSI_Invalid_Cmd:
        PUSH     {LR}
        CFI R14 Frame(CFA, -4)
        CFI CFA R13+4
        SUB      SP,SP,#+4
        CFI CFA R13+8
//  337   if (CBW.dDataLength == 0)
        LDR.N    R0,??DataTable16  ;; CBW
        LDR      R1,[R0, #+8]
        CBNZ     R1,??SCSI_Invalid_Cmd_0
//  338   {
//  339     Bot_Abort(DIR_IN);
        MOVS     R0,#+0
        B.N      ??SCSI_Invalid_Cmd_1
//  340   }
//  341   else
//  342   {
//  343     if ((CBW.bmFlags & 0x80) != 0)
??SCSI_Invalid_Cmd_0:
        LDRB     R0,[R0, #+12]
        TST      R0,#0x80
        BEQ.N    ??SCSI_Invalid_Cmd_2
//  344     {
//  345       Bot_Abort(DIR_IN);
        MOVS     R0,#+0
        B.N      ??SCSI_Invalid_Cmd_1
//  346     }
//  347     else
//  348     {
//  349       Bot_Abort(BOTH_DIR);
??SCSI_Invalid_Cmd_2:
        MOVS     R0,#+2
??SCSI_Invalid_Cmd_1:
        BL       Bot_Abort
//  350     }
//  351   }
//  352   Set_Scsi_Sense_Data(ILLEGAL_REQUEST, INVALID_COMMAND);
        MOVS     R1,#+32
        MOVS     R0,#+5
        BL       Set_Scsi_Sense_Data
//  353   Set_CSW (CSW_CMD_FAILED, SEND_CSW_DISABLE);
        MOVS     R1,#+0
        MOVS     R0,#+1
        ADD      SP,SP,#+4
        CFI CFA R13+4
        POP      {LR}
        CFI R14 SameValue
        CFI CFA R13+0
        B.W      Set_CSW
        CFI EndBlock cfiBlock14
//  354 }
//  355 
//  356 /*******************************************************************************
//  357 * Function Name  : SCSI_Address_Management
//  358 * Description    : Test the received address.
//  359 * Input          : u8 Cmd : the command can be SCSI_READ10 or SCSI_WRITE10.
//  360 * Output         : None.
//  361 * Return         : Read\Write status (bool).
//  362 *******************************************************************************/

        SECTION `.text`:CODE:NOROOT(2)
        CFI Block cfiBlock15 Using cfiCommon0
        CFI Function SCSI_Address_Management
        THUMB
//  363 bool SCSI_Address_Management(u8 Cmd , u32 LBA , u32 BlockNbr)
//  364 {
SCSI_Address_Management:
        PUSH     {LR}
        CFI R14 Frame(CFA, -4)
        CFI CFA R13+4
        SUB      SP,SP,#+4
        CFI CFA R13+8
//  365 
//  366   if ((LBA + BlockNbr) > Mass_Block_Count )
        LDR.N    R3,??DataTable15  ;; Mass_Block_Count
        LDR      R3,[R3, #+0]
        ADDS     R1,R2,R1
        CMP      R3,R1
        BCS.N    ??SCSI_Address_Management_0
//  367   {
//  368     if (Cmd == SCSI_WRITE10)
        CMP      R0,#+42
        BNE.N    ??SCSI_Address_Management_1
//  369     {
//  370       Bot_Abort(BOTH_DIR);
        MOVS     R0,#+2
        BL       Bot_Abort
//  371     }
//  372     Bot_Abort(DIR_IN);
??SCSI_Address_Management_1:
        MOVS     R0,#+0
        BL       Bot_Abort
//  373     Set_Scsi_Sense_Data(ILLEGAL_REQUEST, ADDRESS_OUT_OF_RANGE);
        MOVS     R1,#+33
??SCSI_Address_Management_2:
        MOVS     R0,#+5
        BL       Set_Scsi_Sense_Data
//  374     Set_CSW (CSW_CMD_FAILED, SEND_CSW_DISABLE);
        MOVS     R1,#+0
        MOVS     R0,#+1
        BL       Set_CSW
//  375     return (FALSE);
        MOVS     R0,#+0
        B.N      ??SCSI_Address_Management_3
//  376   }
//  377 
//  378 
//  379   if (CBW.dDataLength != BlockNbr * Mass_Block_Size)
??SCSI_Address_Management_0:
        LDR.N    R1,??DataTable16  ;; CBW
        LDR      R1,[R1, #+8]
        LDR.N    R3,??DataTable17  ;; Mass_Block_Size
        LDR      R3,[R3, #+0]
        MULS     R2,R2,R3
        CMP      R1,R2
        BEQ.N    ??SCSI_Address_Management_4
//  380   {
//  381     if (Cmd == SCSI_WRITE10)
        CMP      R0,#+42
        BNE.N    ??SCSI_Address_Management_5
//  382     {
//  383       Bot_Abort(BOTH_DIR);
        MOVS     R0,#+2
        B.N      ??SCSI_Address_Management_6
//  384     }
//  385     else
//  386     {
//  387       Bot_Abort(DIR_IN);
??SCSI_Address_Management_5:
        MOVS     R0,#+0
??SCSI_Address_Management_6:
        BL       Bot_Abort
//  388     }
//  389     Set_Scsi_Sense_Data(ILLEGAL_REQUEST, INVALID_FIELED_IN_COMMAND);
        MOVS     R1,#+36
        B.N      ??SCSI_Address_Management_2
//  390     Set_CSW (CSW_CMD_FAILED, SEND_CSW_DISABLE);
//  391     return (FALSE);
//  392   }
//  393   return (TRUE);
??SCSI_Address_Management_4:
        MOVS     R0,#+1
??SCSI_Address_Management_3:
        ADD      SP,SP,#+4
        CFI CFA R13+4
        POP      {PC}             ;; return
        CFI EndBlock cfiBlock15
//  394 }

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable15:
        DC32     Mass_Block_Count

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable16:
        DC32     CBW

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17:
        DC32     Mass_Block_Size

        END
//  395 /******************* (C) COPYRIGHT 2008 STMicroelectronics *****END OF FILE****/
// 
// 660 bytes in section .text
// 
// 660 bytes of CODE memory
//
//Errors: none
//Warnings: none
