///////////////////////////////////////////////////////////////////////////////
//                                                                            /
//                                                      09/Aug/2011  14:03:49 /
// IAR ANSI C/C++ Compiler V5.20.0.20892/W32 EVALUATION for ARM               /
// Copyright 1999-2008 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  E:\Mini-DS\DS203\FWLib\src\stm32f10x_dma.c              /
//    Command line =  E:\Mini-DS\DS203\FWLib\src\stm32f10x_dma.c -lA          /
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
//    List file    =  E:\Mini-DS\DS203\SYS_V1.50\IAR_V5_Prpject\List\stm32f10 /
//                    x_dma.s                                                 /
//                                                                            /
//                                                                            /
///////////////////////////////////////////////////////////////////////////////

        NAME stm32f10x_dma

        PUBLIC DMA_ClearFlag
        PUBLIC DMA_ClearITPendingBit
        PUBLIC DMA_Cmd
        PUBLIC DMA_DeInit
        PUBLIC DMA_GetCurrDataCounter
        PUBLIC DMA_GetFlagStatus
        PUBLIC DMA_GetITStatus
        PUBLIC DMA_ITConfig
        PUBLIC DMA_Init
        PUBLIC DMA_StructInit
        
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
        
// E:\Mini-DS\DS203\FWLib\src\stm32f10x_dma.c
//    1 /******************** (C) COPYRIGHT 2008 STMicroelectronics ********************
//    2 * File Name          : stm32f10x_dma.c
//    3 * Author             : MCD Application Team
//    4 * Version            : V2.0.3
//    5 * Date               : 09/22/2008
//    6 * Description        : This file provides all the DMA firmware functions.
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
//   17 #include "stm32f10x_dma.h"
//   18 #include "stm32f10x_rcc.h"
//   19 
//   20 /* Private typedef -----------------------------------------------------------*/
//   21 /* Private define ------------------------------------------------------------*/
//   22 /* DMA ENABLE mask */
//   23 #define CCR_ENABLE_Set          ((u32)0x00000001)
//   24 #define CCR_ENABLE_Reset        ((u32)0xFFFFFFFE)
//   25 
//   26 /* DMA1 Channelx interrupt pending bit masks */
//   27 #define DMA1_Channel1_IT_Mask    ((u32)0x0000000F)
//   28 #define DMA1_Channel2_IT_Mask    ((u32)0x000000F0)
//   29 #define DMA1_Channel3_IT_Mask    ((u32)0x00000F00)
//   30 #define DMA1_Channel4_IT_Mask    ((u32)0x0000F000)
//   31 #define DMA1_Channel5_IT_Mask    ((u32)0x000F0000)
//   32 #define DMA1_Channel6_IT_Mask    ((u32)0x00F00000)
//   33 #define DMA1_Channel7_IT_Mask    ((u32)0x0F000000)
//   34 
//   35 /* DMA2 Channelx interrupt pending bit masks */
//   36 #define DMA2_Channel1_IT_Mask    ((u32)0x0000000F)
//   37 #define DMA2_Channel2_IT_Mask    ((u32)0x000000F0)
//   38 #define DMA2_Channel3_IT_Mask    ((u32)0x00000F00)
//   39 #define DMA2_Channel4_IT_Mask    ((u32)0x0000F000)
//   40 #define DMA2_Channel5_IT_Mask    ((u32)0x000F0000)
//   41 
//   42 /* DMA2 FLAG mask */
//   43 #define FLAG_Mask                ((u32)0x10000000)
//   44 
//   45 /* DMA registers Masks */
//   46 #define CCR_CLEAR_Mask           ((u32)0xFFFF800F)
//   47 
//   48 /* Private macro -------------------------------------------------------------*/
//   49 /* Private variables ---------------------------------------------------------*/
//   50 /* Private function prototypes -----------------------------------------------*/
//   51 /* Private functions ---------------------------------------------------------*/
//   52 
//   53 /*******************************************************************************
//   54 * Function Name  : DMA_DeInit
//   55 * Description    : Deinitializes the DMAy Channelx registers to their default reset
//   56 *                  values.
//   57 * Input          : - DMAy_Channelx: where y can be 1 or 2 to select the DMA and
//   58 *                    x can be 1 to 7 for DMA1 and 1 to 5 for DMA2 to select the 
//   59 *                    DMA Channel.
//   60 * Output         : None
//   61 * Return         : None
//   62 *******************************************************************************/

        SECTION `.text`:CODE:NOROOT(2)
        CFI Block cfiBlock0 Using cfiCommon0
        CFI Function DMA_DeInit
        THUMB
//   63 void DMA_DeInit(DMA_Channel_TypeDef* DMAy_Channelx)
//   64 {
//   65   /* Check the parameters */
//   66   assert_param(IS_DMA_ALL_PERIPH(DMAy_Channelx));
//   67 
//   68   /* Disable the selected DMAy Channelx */
//   69   DMAy_Channelx->CCR &= CCR_ENABLE_Reset;
DMA_DeInit:
        LDR      R1,[R0, #+0]
        MOVS     R2,#+1
        BICS     R1,R1,R2
        STR      R1,[R0, #+0]
//   70 
//   71   /* Reset DMAy Channelx control register */
//   72   DMAy_Channelx->CCR  = 0;
        MOVS     R1,#+0
        STR      R1,[R0, #+0]
//   73   
//   74   /* Reset DMAy Channelx remaining bytes register */
//   75   DMAy_Channelx->CNDTR = 0;
        STR      R1,[R0, #+4]
//   76   
//   77   /* Reset DMAy Channelx peripheral address register */
//   78   DMAy_Channelx->CPAR  = 0;
        STR      R1,[R0, #+8]
//   79   
//   80   /* Reset DMAy Channelx memory address register */
//   81   DMAy_Channelx->CMAR = 0;
        STR      R1,[R0, #+12]
//   82 
//   83   switch (*(u32*)&DMAy_Channelx)
        LDR.N    R1,??DMA_DeInit_0  ;; 0x40020008
        SUBS     R0,R0,R1
        BEQ.N    ??DMA_DeInit_1
        SUBS     R0,R0,#+20
        BEQ.N    ??DMA_DeInit_2
        SUBS     R0,R0,#+20
        BEQ.N    ??DMA_DeInit_3
        SUBS     R0,R0,#+20
        BEQ.N    ??DMA_DeInit_4
        SUBS     R0,R0,#+20
        BEQ.N    ??DMA_DeInit_5
        SUBS     R0,R0,#+20
        BEQ.N    ??DMA_DeInit_6
        SUBS     R0,R0,#+20
        BEQ.N    ??DMA_DeInit_7
        MOV      R1,#+904
        SUBS     R0,R0,R1
        BEQ.N    ??DMA_DeInit_8
        SUBS     R0,R0,#+20
        BEQ.N    ??DMA_DeInit_9
        SUBS     R0,R0,#+20
        BEQ.N    ??DMA_DeInit_10
        SUBS     R0,R0,#+20
        BEQ.N    ??DMA_DeInit_11
        SUBS     R0,R0,#+20
        BEQ.N    ??DMA_DeInit_12
        BX       LR
//   84   {
//   85     case DMA1_Channel1_BASE:
//   86       /* Reset interrupt pending bits for DMA1 Channel1 */
//   87       DMA1->IFCR |= DMA1_Channel1_IT_Mask;
??DMA_DeInit_1:
        LDR.N    R0,??DataTable24  ;; 0x40020004
        LDR      R1,[R0, #+0]
        ORR      R1,R1,#0xF
??DMA_DeInit_13:
        STR      R1,[R0, #+0]
        BX       LR
//   88       break;
//   89 
//   90     case DMA1_Channel2_BASE:
//   91       /* Reset interrupt pending bits for DMA1 Channel2 */
//   92       DMA1->IFCR |= DMA1_Channel2_IT_Mask;
??DMA_DeInit_2:
        LDR.N    R0,??DataTable24  ;; 0x40020004
        LDR      R1,[R0, #+0]
        ORR      R1,R1,#0xF0
        B.N      ??DMA_DeInit_13
//   93       break;
//   94 
//   95     case DMA1_Channel3_BASE:
//   96       /* Reset interrupt pending bits for DMA1 Channel3 */
//   97       DMA1->IFCR |= DMA1_Channel3_IT_Mask;
??DMA_DeInit_3:
        LDR.N    R0,??DataTable24  ;; 0x40020004
        LDR      R1,[R0, #+0]
        ORR      R1,R1,#0xF00
??DMA_DeInit_14:
        STR      R1,[R0, #+0]
        BX       LR
//   98       break;
//   99 
//  100     case DMA1_Channel4_BASE:
//  101       /* Reset interrupt pending bits for DMA1 Channel4 */
//  102       DMA1->IFCR |= DMA1_Channel4_IT_Mask;
??DMA_DeInit_4:
        LDR.N    R0,??DataTable24  ;; 0x40020004
        LDR      R1,[R0, #+0]
        ORR      R1,R1,#0xF000
        B.N      ??DMA_DeInit_13
//  103       break;
//  104 
//  105     case DMA1_Channel5_BASE:
//  106       /* Reset interrupt pending bits for DMA1 Channel5 */
//  107       DMA1->IFCR |= DMA1_Channel5_IT_Mask;
??DMA_DeInit_5:
        LDR.N    R0,??DataTable24  ;; 0x40020004
        LDR      R1,[R0, #+0]
        ORR      R1,R1,#0xF0000
        B.N      ??DMA_DeInit_14
//  108       break;
//  109 
//  110     case DMA1_Channel6_BASE:
//  111       /* Reset interrupt pending bits for DMA1 Channel6 */
//  112       DMA1->IFCR |= DMA1_Channel6_IT_Mask;
??DMA_DeInit_6:
        LDR.N    R0,??DataTable24  ;; 0x40020004
        LDR      R1,[R0, #+0]
        ORR      R1,R1,#0xF00000
        B.N      ??DMA_DeInit_13
//  113       break;
//  114 
//  115     case DMA1_Channel7_BASE:
//  116       /* Reset interrupt pending bits for DMA1 Channel7 */
//  117       DMA1->IFCR |= DMA1_Channel7_IT_Mask;
??DMA_DeInit_7:
        LDR.N    R0,??DataTable24  ;; 0x40020004
        LDR      R1,[R0, #+0]
        ORR      R1,R1,#0xF000000
        STR      R1,[R0, #+0]
        BX       LR
//  118       break;
//  119 
//  120     case DMA2_Channel1_BASE:
//  121       /* Reset interrupt pending bits for DMA2 Channel1 */
//  122       DMA2->IFCR |= DMA2_Channel1_IT_Mask;
??DMA_DeInit_8:
        LDR.N    R0,??DataTable24  ;; 0x40020004
        ADD      R0,R0,#+1024
        LDR      R0,[R0, #+0]
        ORR      R0,R0,#0xF
        LDR.N    R1,??DataTable24  ;; 0x40020004
        ADD      R1,R1,#+1024
        B.N      ??DMA_DeInit_15
//  123       break;
//  124 
//  125     case DMA2_Channel2_BASE:
//  126       /* Reset interrupt pending bits for DMA2 Channel2 */
//  127       DMA2->IFCR |= DMA2_Channel2_IT_Mask;
??DMA_DeInit_9:
        LDR.N    R0,??DataTable24  ;; 0x40020004
        ADD      R0,R0,#+1024
        LDR      R0,[R0, #+0]
        ORR      R0,R0,#0xF0
        LDR.N    R1,??DataTable24  ;; 0x40020004
        ADD      R1,R1,#+1024
        B.N      ??DMA_DeInit_15
//  128       break;
//  129 
//  130     case DMA2_Channel3_BASE:
//  131       /* Reset interrupt pending bits for DMA2 Channel3 */
//  132       DMA2->IFCR |= DMA2_Channel3_IT_Mask;
??DMA_DeInit_10:
        LDR.N    R0,??DataTable24  ;; 0x40020004
        ADD      R0,R0,#+1024
        LDR      R0,[R0, #+0]
        ORR      R0,R0,#0xF00
        LDR.N    R1,??DataTable24  ;; 0x40020004
        ADD      R1,R1,#+1024
        B.N      ??DMA_DeInit_15
//  133       break;
//  134 
//  135     case DMA2_Channel4_BASE:
//  136       /* Reset interrupt pending bits for DMA2 Channel4 */
//  137       DMA2->IFCR |= DMA2_Channel4_IT_Mask;
??DMA_DeInit_11:
        LDR.N    R0,??DataTable24  ;; 0x40020004
        ADD      R0,R0,#+1024
        LDR      R0,[R0, #+0]
        ORR      R0,R0,#0xF000
        LDR.N    R1,??DataTable24  ;; 0x40020004
        ADD      R1,R1,#+1024
        B.N      ??DMA_DeInit_15
//  138       break;
//  139 
//  140     case DMA2_Channel5_BASE:
//  141       /* Reset interrupt pending bits for DMA2 Channel5 */
//  142       DMA2->IFCR |= DMA2_Channel5_IT_Mask;
??DMA_DeInit_12:
        LDR.N    R0,??DataTable24  ;; 0x40020004
        ADD      R0,R0,#+1024
        LDR      R0,[R0, #+0]
        ORR      R0,R0,#0xF0000
        LDR.N    R1,??DataTable24  ;; 0x40020004
        ADD      R1,R1,#+1024
??DMA_DeInit_15:
        STR      R0,[R1, #+0]
//  143       break;
//  144       
//  145     default:
//  146       break;
//  147   }
//  148 }
??DMA_DeInit_16:
        BX       LR               ;; return
        DATA
??DMA_DeInit_0:
        DC32     0x40020008
        CFI EndBlock cfiBlock0
//  149 
//  150 /*******************************************************************************
//  151 * Function Name  : DMA_Init
//  152 * Description    : Initializes the DMAy Channelx according to the specified
//  153 *                  parameters in the DMA_InitStruct.
//  154 * Input          : - DMAy_Channelx: where y can be 1 or 2 to select the DMA and 
//  155 *                    x can be 1 to 7 for DMA1 and 1 to 5 for DMA2 to select the 
//  156 *                    DMA Channel.
//  157 *                  - DMA_InitStruct: pointer to a DMA_InitTypeDef structure that
//  158 *                    contains the configuration information for the specified
//  159 *                    DMA Channel.
//  160 * Output         : None
//  161 * Return         : None
//  162 ******************************************************************************/

        SECTION `.text`:CODE:NOROOT(2)
        CFI Block cfiBlock1 Using cfiCommon0
        CFI Function DMA_Init
        THUMB
//  163 void DMA_Init(DMA_Channel_TypeDef* DMAy_Channelx, DMA_InitTypeDef* DMA_InitStruct)
//  164 {
//  165   u32 tmpreg = 0;
//  166 
//  167   /* Check the parameters */
//  168   assert_param(IS_DMA_ALL_PERIPH(DMAy_Channelx));
//  169   assert_param(IS_DMA_DIR(DMA_InitStruct->DMA_DIR));
//  170   assert_param(IS_DMA_BUFFER_SIZE(DMA_InitStruct->DMA_BufferSize));
//  171   assert_param(IS_DMA_PERIPHERAL_INC_STATE(DMA_InitStruct->DMA_PeripheralInc));
//  172   assert_param(IS_DMA_MEMORY_INC_STATE(DMA_InitStruct->DMA_MemoryInc));   
//  173   assert_param(IS_DMA_PERIPHERAL_DATA_SIZE(DMA_InitStruct->DMA_PeripheralDataSize));
//  174   assert_param(IS_DMA_MEMORY_DATA_SIZE(DMA_InitStruct->DMA_MemoryDataSize));
//  175   assert_param(IS_DMA_MODE(DMA_InitStruct->DMA_Mode));
//  176   assert_param(IS_DMA_PRIORITY(DMA_InitStruct->DMA_Priority));
//  177   assert_param(IS_DMA_M2M_STATE(DMA_InitStruct->DMA_M2M));
//  178 
//  179 /*--------------------------- DMAy Channelx CCR Configuration -----------------*/
//  180   /* Get the DMAy_Channelx CCR value */
//  181   tmpreg = DMAy_Channelx->CCR;
DMA_Init:
        LDR      R2,[R0, #+0]
//  182   /* Clear MEM2MEM, PL, MSIZE, PSIZE, MINC, PINC, CIRC and DIR bits */
//  183   tmpreg &= CCR_CLEAR_Mask;
//  184   /* Configure DMAy Channelx: data transfer, data size, priority level and mode */
//  185   /* Set DIR bit according to DMA_DIR value */
//  186   /* Set CIRC bit according to DMA_Mode value */
//  187   /* Set PINC bit according to DMA_PeripheralInc value */
//  188   /* Set MINC bit according to DMA_MemoryInc value */
//  189   /* Set PSIZE bits according to DMA_PeripheralDataSize value */
//  190   /* Set MSIZE bits according to DMA_MemoryDataSize value */
//  191   /* Set PL bits according to DMA_Priority value */
//  192   /* Set the MEM2MEM bit according to DMA_M2M value */
//  193   tmpreg |= DMA_InitStruct->DMA_DIR | DMA_InitStruct->DMA_Mode |
//  194             DMA_InitStruct->DMA_PeripheralInc | DMA_InitStruct->DMA_MemoryInc |
//  195             DMA_InitStruct->DMA_PeripheralDataSize | DMA_InitStruct->DMA_MemoryDataSize |
//  196             DMA_InitStruct->DMA_Priority | DMA_InitStruct->DMA_M2M;
//  197   /* Write to DMAy Channelx CCR */
//  198   DMAy_Channelx->CCR = tmpreg;
        LDR.N    R3,??DMA_Init_0  ;; 0xffff800f
        ANDS     R2,R3,R2
        LDR      R3,[R1, #+8]
        ORRS     R2,R3,R2
        LDR      R3,[R1, #+32]
        ORRS     R2,R3,R2
        LDR      R3,[R1, #+16]
        ORRS     R2,R3,R2
        LDR      R3,[R1, #+20]
        ORRS     R2,R3,R2
        LDR      R3,[R1, #+24]
        ORRS     R2,R3,R2
        LDR      R3,[R1, #+28]
        ORRS     R2,R3,R2
        LDR      R3,[R1, #+36]
        ORRS     R2,R3,R2
        LDR      R3,[R1, #+40]
        ORRS     R2,R3,R2
        STR      R2,[R0, #+0]
//  199 
//  200 /*--------------------------- DMAy Channelx CNDTR Configuration ---------------*/
//  201   /* Write to DMAy Channelx CNDTR */
//  202   DMAy_Channelx->CNDTR = DMA_InitStruct->DMA_BufferSize;
        LDR      R2,[R1, #+12]
        STR      R2,[R0, #+4]
//  203 
//  204 /*--------------------------- DMAy Channelx CPAR Configuration ----------------*/
//  205   /* Write to DMAy Channelx CPAR */
//  206   DMAy_Channelx->CPAR = DMA_InitStruct->DMA_PeripheralBaseAddr;
        LDR      R2,[R1, #+0]
        STR      R2,[R0, #+8]
//  207 
//  208 /*--------------------------- DMAy Channelx CMAR Configuration ----------------*/
//  209   /* Write to DMAy Channelx CMAR */
//  210   DMAy_Channelx->CMAR = DMA_InitStruct->DMA_MemoryBaseAddr;
        LDR      R1,[R1, #+4]
        STR      R1,[R0, #+12]
//  211 }
        BX       LR               ;; return
        Nop      
        DATA
??DMA_Init_0:
        DC32     0xffff800f
        CFI EndBlock cfiBlock1
//  212 
//  213 /*******************************************************************************
//  214 * Function Name  : DMA_StructInit
//  215 * Description    : Fills each DMA_InitStruct member with its default value.
//  216 * Input          : - DMA_InitStruct : pointer to a DMA_InitTypeDef structure
//  217 *                    which will be initialized.
//  218 * Output         : None
//  219 * Return         : None
//  220 *******************************************************************************/

        SECTION `.text`:CODE:NOROOT(2)
        CFI Block cfiBlock2 Using cfiCommon0
        CFI Function DMA_StructInit
        THUMB
//  221 void DMA_StructInit(DMA_InitTypeDef* DMA_InitStruct)
//  222 {
//  223 /*-------------- Reset DMA init structure parameters values ------------------*/
//  224   /* Initialize the DMA_PeripheralBaseAddr member */
//  225   DMA_InitStruct->DMA_PeripheralBaseAddr = 0;
DMA_StructInit:
        MOVS     R1,#+0
        STR      R1,[R0, #+0]
//  226 
//  227   /* Initialize the DMA_MemoryBaseAddr member */
//  228   DMA_InitStruct->DMA_MemoryBaseAddr = 0;
        STR      R1,[R0, #+4]
//  229 
//  230   /* Initialize the DMA_DIR member */
//  231   DMA_InitStruct->DMA_DIR = DMA_DIR_PeripheralSRC;
        STR      R1,[R0, #+8]
//  232 
//  233   /* Initialize the DMA_BufferSize member */
//  234   DMA_InitStruct->DMA_BufferSize = 0;
        STR      R1,[R0, #+12]
//  235 
//  236   /* Initialize the DMA_PeripheralInc member */
//  237   DMA_InitStruct->DMA_PeripheralInc = DMA_PeripheralInc_Disable;
        STR      R1,[R0, #+16]
//  238 
//  239   /* Initialize the DMA_MemoryInc member */
//  240   DMA_InitStruct->DMA_MemoryInc = DMA_MemoryInc_Disable;
        STR      R1,[R0, #+20]
//  241 
//  242   /* Initialize the DMA_PeripheralDataSize member */
//  243   DMA_InitStruct->DMA_PeripheralDataSize = DMA_PeripheralDataSize_Byte;
        STR      R1,[R0, #+24]
//  244 
//  245   /* Initialize the DMA_MemoryDataSize member */
//  246   DMA_InitStruct->DMA_MemoryDataSize = DMA_MemoryDataSize_Byte;
        STR      R1,[R0, #+28]
//  247 
//  248   /* Initialize the DMA_Mode member */
//  249   DMA_InitStruct->DMA_Mode = DMA_Mode_Normal;
        STR      R1,[R0, #+32]
//  250 
//  251   /* Initialize the DMA_Priority member */
//  252   DMA_InitStruct->DMA_Priority = DMA_Priority_Low;
        STR      R1,[R0, #+36]
//  253 
//  254   /* Initialize the DMA_M2M member */
//  255   DMA_InitStruct->DMA_M2M = DMA_M2M_Disable;
        STR      R1,[R0, #+40]
//  256 }
        BX       LR               ;; return
        CFI EndBlock cfiBlock2
//  257 
//  258 /*******************************************************************************
//  259 * Function Name  : DMA_Cmd
//  260 * Description    : Enables or disables the specified DMAy Channelx.
//  261 * Input          : - DMAy_Channelx: where y can be 1 or 2 to select the DMA and 
//  262 *                    x can be 1 to 7 for DMA1 and 1 to 5 for DMA2 to select the 
//  263 *                    DMA Channel.
//  264 *                  - NewState: new state of the DMAy Channelx. 
//  265 *                    This parameter can be: ENABLE or DISABLE.
//  266 * Output         : None
//  267 * Return         : None
//  268 *******************************************************************************/

        SECTION `.text`:CODE:NOROOT(2)
        CFI Block cfiBlock3 Using cfiCommon0
        CFI Function DMA_Cmd
        THUMB
//  269 void DMA_Cmd(DMA_Channel_TypeDef* DMAy_Channelx, FunctionalState NewState)
//  270 {
//  271   /* Check the parameters */
//  272   assert_param(IS_DMA_ALL_PERIPH(DMAy_Channelx));
//  273   assert_param(IS_FUNCTIONAL_STATE(NewState));
//  274 
//  275   if (NewState != DISABLE)
DMA_Cmd:
        CMP      R1,#+0
        LDR      R1,[R0, #+0]
        BEQ.N    ??DMA_Cmd_0
//  276   {
//  277     /* Enable the selected DMAy Channelx */
//  278     DMAy_Channelx->CCR |= CCR_ENABLE_Set;
        ORR      R1,R1,#0x1
        B.N      ??DMA_Cmd_1
//  279   }
//  280   else
//  281   {
//  282     /* Disable the selected DMAy Channelx */
//  283     DMAy_Channelx->CCR &= CCR_ENABLE_Reset;
??DMA_Cmd_0:
        MOVS     R2,#+1
        BICS     R1,R1,R2
??DMA_Cmd_1:
        STR      R1,[R0, #+0]
//  284   }
//  285 }
        BX       LR               ;; return
        CFI EndBlock cfiBlock3
//  286 
//  287 /*******************************************************************************
//  288 * Function Name  : DMA_ITConfig
//  289 * Description    : Enables or disables the specified DMAy Channelx interrupts.
//  290 * Input          : - DMAy_Channelx: where y can be 1 or 2 to select the DMA and 
//  291 *                    x can be 1 to 7 for DMA1 and 1 to 5 for DMA2 to select the 
//  292 *                    DMA Channel.
//  293 *                  - DMA_IT: specifies the DMA interrupts sources to be enabled
//  294 *                    or disabled. 
//  295 *                    This parameter can be any combination of the following values:
//  296 *                       - DMA_IT_TC:  Transfer complete interrupt mask
//  297 *                       - DMA_IT_HT:  Half transfer interrupt mask
//  298 *                       - DMA_IT_TE:  Transfer error interrupt mask
//  299 *                  - NewState: new state of the specified DMA interrupts.
//  300 *                    This parameter can be: ENABLE or DISABLE.
//  301 * Output         : None
//  302 * Return         : None
//  303 *******************************************************************************/

        SECTION `.text`:CODE:NOROOT(2)
        CFI Block cfiBlock4 Using cfiCommon0
        CFI Function DMA_ITConfig
        THUMB
//  304 void DMA_ITConfig(DMA_Channel_TypeDef* DMAy_Channelx, u32 DMA_IT, FunctionalState NewState)
//  305 {
//  306   /* Check the parameters */
//  307   assert_param(IS_DMA_ALL_PERIPH(DMAy_Channelx));
//  308   assert_param(IS_DMA_CONFIG_IT(DMA_IT));
//  309   assert_param(IS_FUNCTIONAL_STATE(NewState));
//  310 
//  311   if (NewState != DISABLE)
DMA_ITConfig:
        CMP      R2,#+0
        LDR      R2,[R0, #+0]
        BEQ.N    ??DMA_ITConfig_0
//  312   {
//  313     /* Enable the selected DMA interrupts */
//  314     DMAy_Channelx->CCR |= DMA_IT;
        ORRS     R1,R1,R2
        B.N      ??DMA_ITConfig_1
//  315   }
//  316   else
//  317   {
//  318     /* Disable the selected DMA interrupts */
//  319     DMAy_Channelx->CCR &= ~DMA_IT;
??DMA_ITConfig_0:
        MVNS     R1,R1
        ANDS     R1,R1,R2
??DMA_ITConfig_1:
        STR      R1,[R0, #+0]
//  320   }
//  321 }
        BX       LR               ;; return
        CFI EndBlock cfiBlock4
//  322 
//  323 /*******************************************************************************
//  324 * Function Name  : DMA_GetCurrDataCounter
//  325 * Description    : Returns the number of remaining data units in the current
//  326 *                  DMAy Channelx transfer.
//  327 * Input          : - DMAy_Channelx: where y can be 1 or 2 to select the DMA and 
//  328 *                    x can be 1 to 7 for DMA1 and 1 to 5 for DMA2 to select the 
//  329 *                    DMA Channel.
//  330 * Output         : None
//  331 * Return         : The number of remaining data units in the current DMAy Channelx
//  332 *                  transfer.
//  333 *******************************************************************************/

        SECTION `.text`:CODE:NOROOT(2)
        CFI Block cfiBlock5 Using cfiCommon0
        CFI Function DMA_GetCurrDataCounter
        THUMB
//  334 u16 DMA_GetCurrDataCounter(DMA_Channel_TypeDef* DMAy_Channelx)
//  335 {
//  336   /* Check the parameters */
//  337   assert_param(IS_DMA_ALL_PERIPH(DMAy_Channelx));
//  338 
//  339   /* Return the number of remaining data units for DMAy Channelx */
//  340   return ((u16)(DMAy_Channelx->CNDTR));
DMA_GetCurrDataCounter:
        LDR      R0,[R0, #+4]
        UXTH     R0,R0
        BX       LR               ;; return
        CFI EndBlock cfiBlock5
//  341 }
//  342 
//  343 /*******************************************************************************
//  344 * Function Name  : DMA_GetFlagStatus
//  345 * Description    : Checks whether the specified DMAy Channelx flag is set or not.
//  346 * Input          : - DMA_FLAG: specifies the flag to check.
//  347 *                    This parameter can be one of the following values:
//  348 *                       - DMA1_FLAG_GL1: DMA1 Channel1 global flag.
//  349 *                       - DMA1_FLAG_TC1: DMA1 Channel1 transfer complete flag.
//  350 *                       - DMA1_FLAG_HT1: DMA1 Channel1 half transfer flag.
//  351 *                       - DMA1_FLAG_TE1: DMA1 Channel1 transfer error flag.
//  352 *                       - DMA1_FLAG_GL2: DMA1 Channel2 global flag.
//  353 *                       - DMA1_FLAG_TC2: DMA1 Channel2 transfer complete flag.
//  354 *                       - DMA1_FLAG_HT2: DMA1 Channel2 half transfer flag.
//  355 *                       - DMA1_FLAG_TE2: DMA1 Channel2 transfer error flag.
//  356 *                       - DMA1_FLAG_GL3: DMA1 Channel3 global flag.
//  357 *                       - DMA1_FLAG_TC3: DMA1 Channel3 transfer complete flag.
//  358 *                       - DMA1_FLAG_HT3: DMA1 Channel3 half transfer flag.
//  359 *                       - DMA1_FLAG_TE3: DMA1 Channel3 transfer error flag.
//  360 *                       - DMA1_FLAG_GL4: DMA1 Channel4 global flag.
//  361 *                       - DMA1_FLAG_TC4: DMA1 Channel4 transfer complete flag.
//  362 *                       - DMA1_FLAG_HT4: DMA1 Channel4 half transfer flag.
//  363 *                       - DMA1_FLAG_TE4: DMA1 Channel4 transfer error flag.
//  364 *                       - DMA1_FLAG_GL5: DMA1 Channel5 global flag.
//  365 *                       - DMA1_FLAG_TC5: DMA1 Channel5 transfer complete flag.
//  366 *                       - DMA1_FLAG_HT5: DMA1 Channel5 half transfer flag.
//  367 *                       - DMA1_FLAG_TE5: DMA1 Channel5 transfer error flag.
//  368 *                       - DMA1_FLAG_GL6: DMA1 Channel6 global flag.
//  369 *                       - DMA1_FLAG_TC6: DMA1 Channel6 transfer complete flag.
//  370 *                       - DMA1_FLAG_HT6: DMA1 Channel6 half transfer flag.
//  371 *                       - DMA1_FLAG_TE6: DMA1 Channel6 transfer error flag.
//  372 *                       - DMA1_FLAG_GL7: DMA1 Channel7 global flag.
//  373 *                       - DMA1_FLAG_TC7: DMA1 Channel7 transfer complete flag.
//  374 *                       - DMA1_FLAG_HT7: DMA1 Channel7 half transfer flag.
//  375 *                       - DMA1_FLAG_TE7: DMA1 Channel7 transfer error flag.
//  376 *                       - DMA2_FLAG_GL1: DMA2 Channel1 global flag.
//  377 *                       - DMA2_FLAG_TC1: DMA2 Channel1 transfer complete flag.
//  378 *                       - DMA2_FLAG_HT1: DMA2 Channel1 half transfer flag.
//  379 *                       - DMA2_FLAG_TE1: DMA2 Channel1 transfer error flag.
//  380 *                       - DMA2_FLAG_GL2: DMA2 Channel2 global flag.
//  381 *                       - DMA2_FLAG_TC2: DMA2 Channel2 transfer complete flag.
//  382 *                       - DMA2_FLAG_HT2: DMA2 Channel2 half transfer flag.
//  383 *                       - DMA2_FLAG_TE2: DMA2 Channel2 transfer error flag.
//  384 *                       - DMA2_FLAG_GL3: DMA2 Channel3 global flag.
//  385 *                       - DMA2_FLAG_TC3: DMA2 Channel3 transfer complete flag.
//  386 *                       - DMA2_FLAG_HT3: DMA2 Channel3 half transfer flag.
//  387 *                       - DMA2_FLAG_TE3: DMA2 Channel3 transfer error flag.
//  388 *                       - DMA2_FLAG_GL4: DMA2 Channel4 global flag.
//  389 *                       - DMA2_FLAG_TC4: DMA2 Channel4 transfer complete flag.
//  390 *                       - DMA2_FLAG_HT4: DMA2 Channel4 half transfer flag.
//  391 *                       - DMA2_FLAG_TE4: DMA2 Channel4 transfer error flag.
//  392 *                       - DMA2_FLAG_GL5: DMA2 Channel5 global flag.
//  393 *                       - DMA2_FLAG_TC5: DMA2 Channel5 transfer complete flag.
//  394 *                       - DMA2_FLAG_HT5: DMA2 Channel5 half transfer flag.
//  395 *                       - DMA2_FLAG_TE5: DMA2 Channel5 transfer error flag.
//  396 * Output         : None
//  397 * Return         : The new state of DMA_FLAG (SET or RESET).
//  398 *******************************************************************************/

        SECTION `.text`:CODE:NOROOT(2)
        CFI Block cfiBlock6 Using cfiCommon0
        CFI Function DMA_GetFlagStatus
        THUMB
//  399 FlagStatus DMA_GetFlagStatus(u32 DMA_FLAG)
//  400 {
//  401   FlagStatus bitstatus = RESET;
//  402   u32 tmpreg = 0;
//  403 
//  404   /* Check the parameters */
//  405   assert_param(IS_DMA_GET_FLAG(DMA_FLAG));
//  406 
//  407   /* Calculate the used DMA */
//  408   if ((DMA_FLAG & FLAG_Mask) != (u32)RESET)
DMA_GetFlagStatus:
        TST      R0,#0x10000000
        BEQ.N    ??DMA_GetFlagStatus_0
//  409   {
//  410     /* Get DMA2 ISR register value */
//  411     tmpreg = DMA2->ISR ;
        LDR.N    R1,??DataTable22  ;; 0x40020000
        ADD      R1,R1,#+1024
        B.N      ??DMA_GetFlagStatus_1
//  412   }
//  413   else
//  414   {
//  415     /* Get DMA1 ISR register value */
//  416     tmpreg = DMA1->ISR ;
??DMA_GetFlagStatus_0:
        LDR.N    R1,??DataTable22  ;; 0x40020000
??DMA_GetFlagStatus_1:
        LDR      R1,[R1, #+0]
//  417   }
//  418 
//  419   /* Check the status of the specified DMA flag */
//  420   if ((tmpreg & DMA_FLAG) != (u32)RESET)
        ANDS     R0,R0,R1
        SUBS     R0,R0,#+1
        SBCS     R0,R0,R0
        MVNS     R0,R0
        LSRS     R0,R0,#+31
//  421   {
//  422     /* DMA_FLAG is set */
//  423     bitstatus = SET;
//  424   }
//  425   else
//  426   {
//  427     /* DMA_FLAG is reset */
//  428     bitstatus = RESET;
//  429   }
//  430   
//  431   /* Return the DMA_FLAG status */
//  432   return  bitstatus;
        BX       LR               ;; return
        CFI EndBlock cfiBlock6
//  433 }
//  434 
//  435 /*******************************************************************************
//  436 * Function Name  : DMA_ClearFlag
//  437 * Description    : Clears the DMAy Channelx's pending flags.
//  438 * Input          : - DMA_FLAG: specifies the flag to clear.
//  439 *                    This parameter can be any combination (for the same DMA) of 
//  440 *                    the following values:
//  441 *                       - DMA1_FLAG_GL1: DMA1 Channel1 global flag.
//  442 *                       - DMA1_FLAG_TC1: DMA1 Channel1 transfer complete flag.
//  443 *                       - DMA1_FLAG_HT1: DMA1 Channel1 half transfer flag.
//  444 *                       - DMA1_FLAG_TE1: DMA1 Channel1 transfer error flag.
//  445 *                       - DMA1_FLAG_GL2: DMA1 Channel2 global flag.
//  446 *                       - DMA1_FLAG_TC2: DMA1 Channel2 transfer complete flag.
//  447 *                       - DMA1_FLAG_HT2: DMA1 Channel2 half transfer flag.
//  448 *                       - DMA1_FLAG_TE2: DMA1 Channel2 transfer error flag.
//  449 *                       - DMA1_FLAG_GL3: DMA1 Channel3 global flag.
//  450 *                       - DMA1_FLAG_TC3: DMA1 Channel3 transfer complete flag.
//  451 *                       - DMA1_FLAG_HT3: DMA1 Channel3 half transfer flag.
//  452 *                       - DMA1_FLAG_TE3: DMA1 Channel3 transfer error flag.
//  453 *                       - DMA1_FLAG_GL4: DMA1 Channel4 global flag.
//  454 *                       - DMA1_FLAG_TC4: DMA1 Channel4 transfer complete flag.
//  455 *                       - DMA1_FLAG_HT4: DMA1 Channel4 half transfer flag.
//  456 *                       - DMA1_FLAG_TE4: DMA1 Channel4 transfer error flag.
//  457 *                       - DMA1_FLAG_GL5: DMA1 Channel5 global flag.
//  458 *                       - DMA1_FLAG_TC5: DMA1 Channel5 transfer complete flag.
//  459 *                       - DMA1_FLAG_HT5: DMA1 Channel5 half transfer flag.
//  460 *                       - DMA1_FLAG_TE5: DMA1 Channel5 transfer error flag.
//  461 *                       - DMA1_FLAG_GL6: DMA1 Channel6 global flag.
//  462 *                       - DMA1_FLAG_TC6: DMA1 Channel6 transfer complete flag.
//  463 *                       - DMA1_FLAG_HT6: DMA1 Channel6 half transfer flag.
//  464 *                       - DMA1_FLAG_TE6: DMA1 Channel6 transfer error flag.
//  465 *                       - DMA1_FLAG_GL7: DMA1 Channel7 global flag.
//  466 *                       - DMA1_FLAG_TC7: DMA1 Channel7 transfer complete flag.
//  467 *                       - DMA1_FLAG_HT7: DMA1 Channel7 half transfer flag.
//  468 *                       - DMA1_FLAG_TE7: DMA1 Channel7 transfer error flag.
//  469 *                       - DMA2_FLAG_GL1: DMA2 Channel1 global flag.
//  470 *                       - DMA2_FLAG_TC1: DMA2 Channel1 transfer complete flag.
//  471 *                       - DMA2_FLAG_HT1: DMA2 Channel1 half transfer flag.
//  472 *                       - DMA2_FLAG_TE1: DMA2 Channel1 transfer error flag.
//  473 *                       - DMA2_FLAG_GL2: DMA2 Channel2 global flag.
//  474 *                       - DMA2_FLAG_TC2: DMA2 Channel2 transfer complete flag.
//  475 *                       - DMA2_FLAG_HT2: DMA2 Channel2 half transfer flag.
//  476 *                       - DMA2_FLAG_TE2: DMA2 Channel2 transfer error flag.
//  477 *                       - DMA2_FLAG_GL3: DMA2 Channel3 global flag.
//  478 *                       - DMA2_FLAG_TC3: DMA2 Channel3 transfer complete flag.
//  479 *                       - DMA2_FLAG_HT3: DMA2 Channel3 half transfer flag.
//  480 *                       - DMA2_FLAG_TE3: DMA2 Channel3 transfer error flag.
//  481 *                       - DMA2_FLAG_GL4: DMA2 Channel4 global flag.
//  482 *                       - DMA2_FLAG_TC4: DMA2 Channel4 transfer complete flag.
//  483 *                       - DMA2_FLAG_HT4: DMA2 Channel4 half transfer flag.
//  484 *                       - DMA2_FLAG_TE4: DMA2 Channel4 transfer error flag.
//  485 *                       - DMA2_FLAG_GL5: DMA2 Channel5 global flag.
//  486 *                       - DMA2_FLAG_TC5: DMA2 Channel5 transfer complete flag.
//  487 *                       - DMA2_FLAG_HT5: DMA2 Channel5 half transfer flag.
//  488 *                       - DMA2_FLAG_TE5: DMA2 Channel5 transfer error flag.
//  489 * Output         : None
//  490 * Return         : None
//  491 *******************************************************************************/

        SECTION `.text`:CODE:NOROOT(2)
        CFI Block cfiBlock7 Using cfiCommon0
        CFI Function DMA_ClearFlag
        THUMB
//  492 void DMA_ClearFlag(u32 DMA_FLAG)
//  493 {
//  494   /* Check the parameters */
//  495   assert_param(IS_DMA_CLEAR_FLAG(DMA_FLAG));
//  496 
//  497   /* Calculate the used DMA */
//  498   if ((DMA_FLAG & FLAG_Mask) != (u32)RESET)
DMA_ClearFlag:
        TST      R0,#0x10000000
        BEQ.N    ??DMA_ClearFlag_0
//  499   {
//  500     /* Clear the selected DMA flags */
//  501     DMA2->IFCR = DMA_FLAG;
        LDR.N    R1,??DataTable24  ;; 0x40020004
        ADD      R1,R1,#+1024
        B.N      ??DMA_ClearFlag_1
//  502   }
//  503   else
//  504   {
//  505     /* Clear the selected DMA flags */
//  506     DMA1->IFCR = DMA_FLAG;
??DMA_ClearFlag_0:
        LDR.N    R1,??DataTable24  ;; 0x40020004
??DMA_ClearFlag_1:
        STR      R0,[R1, #+0]
//  507   }
//  508 }
        BX       LR               ;; return
        CFI EndBlock cfiBlock7
//  509 
//  510 /*******************************************************************************
//  511 * Function Name  : DMA_GetITStatus
//  512 * Description    : Checks whether the specified DMAy Channelx interrupt has 
//  513 *                  occurred or not.
//  514 * Input          : - DMA_IT: specifies the DMA interrupt source to check. 
//  515 *                    This parameter can be one of the following values:
//  516 *                       - DMA1_IT_GL1: DMA1 Channel1 global interrupt.
//  517 *                       - DMA1_IT_TC1: DMA1 Channel1 transfer complete interrupt.
//  518 *                       - DMA1_IT_HT1: DMA1 Channel1 half transfer interrupt.
//  519 *                       - DMA1_IT_TE1: DMA1 Channel1 transfer error interrupt.
//  520 *                       - DMA1_IT_GL2: DMA1 Channel2 global interrupt.
//  521 *                       - DMA1_IT_TC2: DMA1 Channel2 transfer complete interrupt.
//  522 *                       - DMA1_IT_HT2: DMA1 Channel2 half transfer interrupt.
//  523 *                       - DMA1_IT_TE2: DMA1 Channel2 transfer error interrupt.
//  524 *                       - DMA1_IT_GL3: DMA1 Channel3 global interrupt.
//  525 *                       - DMA1_IT_TC3: DMA1 Channel3 transfer complete interrupt.
//  526 *                       - DMA1_IT_HT3: DMA1 Channel3 half transfer interrupt.
//  527 *                       - DMA1_IT_TE3: DMA1 Channel3 transfer error interrupt.
//  528 *                       - DMA1_IT_GL4: DMA1 Channel4 global interrupt.
//  529 *                       - DMA1_IT_TC4: DMA1 Channel4 transfer complete interrupt.
//  530 *                       - DMA1_IT_HT4: DMA1 Channel4 half transfer interrupt.
//  531 *                       - DMA1_IT_TE4: DMA1 Channel4 transfer error interrupt.
//  532 *                       - DMA1_IT_GL5: DMA1 Channel5 global interrupt.
//  533 *                       - DMA1_IT_TC5: DMA1 Channel5 transfer complete interrupt.
//  534 *                       - DMA1_IT_HT5: DMA1 Channel5 half transfer interrupt.
//  535 *                       - DMA1_IT_TE5: DMA1 Channel5 transfer error interrupt.
//  536 *                       - DMA1_IT_GL6: DMA1 Channel6 global interrupt.
//  537 *                       - DMA1_IT_TC6: DMA1 Channel6 transfer complete interrupt.
//  538 *                       - DMA1_IT_HT6: DMA1 Channel6 half transfer interrupt.
//  539 *                       - DMA1_IT_TE6: DMA1 Channel6 transfer error interrupt.
//  540 *                       - DMA1_IT_GL7: DMA1 Channel7 global interrupt.
//  541 *                       - DMA1_IT_TC7: DMA1 Channel7 transfer complete interrupt.
//  542 *                       - DMA1_IT_HT7: DMA1 Channel7 half transfer interrupt.
//  543 *                       - DMA1_IT_TE7: DMA1 Channel7 transfer error interrupt.
//  544 *                       - DMA2_IT_GL1: DMA2 Channel1 global interrupt.
//  545 *                       - DMA2_IT_TC1: DMA2 Channel1 transfer complete interrupt.
//  546 *                       - DMA2_IT_HT1: DMA2 Channel1 half transfer interrupt.
//  547 *                       - DMA2_IT_TE1: DMA2 Channel1 transfer error interrupt.
//  548 *                       - DMA2_IT_GL2: DMA2 Channel2 global interrupt.
//  549 *                       - DMA2_IT_TC2: DMA2 Channel2 transfer complete interrupt.
//  550 *                       - DMA2_IT_HT2: DMA2 Channel2 half transfer interrupt.
//  551 *                       - DMA2_IT_TE2: DMA2 Channel2 transfer error interrupt.
//  552 *                       - DMA2_IT_GL3: DMA2 Channel3 global interrupt.
//  553 *                       - DMA2_IT_TC3: DMA2 Channel3 transfer complete interrupt.
//  554 *                       - DMA2_IT_HT3: DMA2 Channel3 half transfer interrupt.
//  555 *                       - DMA2_IT_TE3: DMA2 Channel3 transfer error interrupt.
//  556 *                       - DMA2_IT_GL4: DMA2 Channel4 global interrupt.
//  557 *                       - DMA2_IT_TC4: DMA2 Channel4 transfer complete interrupt.
//  558 *                       - DMA2_IT_HT4: DMA2 Channel4 half transfer interrupt.
//  559 *                       - DMA2_IT_TE4: DMA2 Channel4 transfer error interrupt.
//  560 *                       - DMA2_IT_GL5: DMA2 Channel5 global interrupt.
//  561 *                       - DMA2_IT_TC5: DMA2 Channel5 transfer complete interrupt.
//  562 *                       - DMA2_IT_HT5: DMA2 Channel5 half transfer interrupt.
//  563 *                       - DMA2_IT_TE5: DMA2 Channel5 transfer error interrupt.
//  564 * Output         : None
//  565 * Return         : The new state of DMA_IT (SET or RESET).
//  566 *******************************************************************************/

        SECTION `.text`:CODE:NOROOT(2)
        CFI Block cfiBlock8 Using cfiCommon0
        CFI Function DMA_GetITStatus
        THUMB
//  567 ITStatus DMA_GetITStatus(u32 DMA_IT)
//  568 {
//  569   ITStatus bitstatus = RESET;
//  570   u32 tmpreg = 0;
//  571 
//  572   /* Check the parameters */
//  573   assert_param(IS_DMA_GET_IT(DMA_IT));
//  574 
//  575   /* Calculate the used DMA */
//  576   if ((DMA_IT & FLAG_Mask) != (u32)RESET)
DMA_GetITStatus:
        TST      R0,#0x10000000
        BEQ.N    ??DMA_GetITStatus_0
//  577   {
//  578     /* Get DMA2 ISR register value */
//  579     tmpreg = DMA2->ISR ;
        LDR.N    R1,??DataTable22  ;; 0x40020000
        ADD      R1,R1,#+1024
        B.N      ??DMA_GetITStatus_1
//  580   }
//  581   else
//  582   {
//  583     /* Get DMA1 ISR register value */
//  584     tmpreg = DMA1->ISR ;
??DMA_GetITStatus_0:
        LDR.N    R1,??DataTable22  ;; 0x40020000
??DMA_GetITStatus_1:
        LDR      R1,[R1, #+0]
//  585   }
//  586 
//  587   /* Check the status of the specified DMA interrupt */
//  588   if ((tmpreg & DMA_IT) != (u32)RESET)
        ANDS     R0,R0,R1
        SUBS     R0,R0,#+1
        SBCS     R0,R0,R0
        MVNS     R0,R0
        LSRS     R0,R0,#+31
//  589   {
//  590     /* DMA_IT is set */
//  591     bitstatus = SET;
//  592   }
//  593   else
//  594   {
//  595     /* DMA_IT is reset */
//  596     bitstatus = RESET;
//  597   }
//  598   /* Return the DMA_IT status */
//  599   return  bitstatus;
        BX       LR               ;; return
        CFI EndBlock cfiBlock8
//  600 }

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable22:
        DC32     0x40020000
//  601 
//  602 /*******************************************************************************
//  603 * Function Name  : DMA_ClearITPendingBit
//  604 * Description    : Clears the DMAy Channelx�s interrupt pending bits.
//  605 * Input          : - DMA_IT: specifies the DMA interrupt pending bit to clear.
//  606 *                    This parameter can be any combination (for the same DMA) of
//  607 *                    the following values:
//  608 *                       - DMA1_IT_GL1: DMA1 Channel1 global interrupt.
//  609 *                       - DMA1_IT_TC1: DMA1 Channel1 transfer complete interrupt.
//  610 *                       - DMA1_IT_HT1: DMA1 Channel1 half transfer interrupt.
//  611 *                       - DMA1_IT_TE1: DMA1 Channel1 transfer error interrupt.
//  612 *                       - DMA1_IT_GL2: DMA1 Channel2 global interrupt.
//  613 *                       - DMA1_IT_TC2: DMA1 Channel2 transfer complete interrupt.
//  614 *                       - DMA1_IT_HT2: DMA1 Channel2 half transfer interrupt.
//  615 *                       - DMA1_IT_TE2: DMA1 Channel2 transfer error interrupt.
//  616 *                       - DMA1_IT_GL3: DMA1 Channel3 global interrupt.
//  617 *                       - DMA1_IT_TC3: DMA1 Channel3 transfer complete interrupt.
//  618 *                       - DMA1_IT_HT3: DMA1 Channel3 half transfer interrupt.
//  619 *                       - DMA1_IT_TE3: DMA1 Channel3 transfer error interrupt.
//  620 *                       - DMA1_IT_GL4: DMA1 Channel4 global interrupt.
//  621 *                       - DMA1_IT_TC4: DMA1 Channel4 transfer complete interrupt.
//  622 *                       - DMA1_IT_HT4: DMA1 Channel4 half transfer interrupt.
//  623 *                       - DMA1_IT_TE4: DMA1 Channel4 transfer error interrupt.
//  624 *                       - DMA1_IT_GL5: DMA1 Channel5 global interrupt.
//  625 *                       - DMA1_IT_TC5: DMA1 Channel5 transfer complete interrupt.
//  626 *                       - DMA1_IT_HT5: DMA1 Channel5 half transfer interrupt.
//  627 *                       - DMA1_IT_TE5: DMA1 Channel5 transfer error interrupt.
//  628 *                       - DMA1_IT_GL6: DMA1 Channel6 global interrupt.
//  629 *                       - DMA1_IT_TC6: DMA1 Channel6 transfer complete interrupt.
//  630 *                       - DMA1_IT_HT6: DMA1 Channel6 half transfer interrupt.
//  631 *                       - DMA1_IT_TE6: DMA1 Channel6 transfer error interrupt.
//  632 *                       - DMA1_IT_GL7: DMA1 Channel7 global interrupt.
//  633 *                       - DMA1_IT_TC7: DMA1 Channel7 transfer complete interrupt.
//  634 *                       - DMA1_IT_HT7: DMA1 Channel7 half transfer interrupt.
//  635 *                       - DMA1_IT_TE7: DMA1 Channel7 transfer error interrupt.
//  636 *                       - DMA2_IT_GL1: DMA2 Channel1 global interrupt.
//  637 *                       - DMA2_IT_TC1: DMA2 Channel1 transfer complete interrupt.
//  638 *                       - DMA2_IT_HT1: DMA2 Channel1 half transfer interrupt.
//  639 *                       - DMA2_IT_TE1: DMA2 Channel1 transfer error interrupt.
//  640 *                       - DMA2_IT_GL2: DMA2 Channel2 global interrupt.
//  641 *                       - DMA2_IT_TC2: DMA2 Channel2 transfer complete interrupt.
//  642 *                       - DMA2_IT_HT2: DMA2 Channel2 half transfer interrupt.
//  643 *                       - DMA2_IT_TE2: DMA2 Channel2 transfer error interrupt.
//  644 *                       - DMA2_IT_GL3: DMA2 Channel3 global interrupt.
//  645 *                       - DMA2_IT_TC3: DMA2 Channel3 transfer complete interrupt.
//  646 *                       - DMA2_IT_HT3: DMA2 Channel3 half transfer interrupt.
//  647 *                       - DMA2_IT_TE3: DMA2 Channel3 transfer error interrupt.
//  648 *                       - DMA2_IT_GL4: DMA2 Channel4 global interrupt.
//  649 *                       - DMA2_IT_TC4: DMA2 Channel4 transfer complete interrupt.
//  650 *                       - DMA2_IT_HT4: DMA2 Channel4 half transfer interrupt.
//  651 *                       - DMA2_IT_TE4: DMA2 Channel4 transfer error interrupt.
//  652 *                       - DMA2_IT_GL5: DMA2 Channel5 global interrupt.
//  653 *                       - DMA2_IT_TC5: DMA2 Channel5 transfer complete interrupt.
//  654 *                       - DMA2_IT_HT5: DMA2 Channel5 half transfer interrupt.
//  655 *                       - DMA2_IT_TE5: DMA2 Channel5 transfer error interrupt.
//  656 * Output         : None
//  657 * Return         : None
//  658 *******************************************************************************/

        SECTION `.text`:CODE:NOROOT(2)
        CFI Block cfiBlock9 Using cfiCommon0
        CFI Function DMA_ClearITPendingBit
        THUMB
//  659 void DMA_ClearITPendingBit(u32 DMA_IT)
//  660 {
//  661   /* Check the parameters */
//  662   assert_param(IS_DMA_CLEAR_IT(DMA_IT));
//  663 
//  664   /* Calculate the used DMA */
//  665   if ((DMA_IT & FLAG_Mask) != (u32)RESET)
DMA_ClearITPendingBit:
        TST      R0,#0x10000000
        BEQ.N    ??DMA_ClearITPendingBit_0
//  666   {
//  667     /* Clear the selected DMA interrupt pending bits */
//  668     DMA2->IFCR = DMA_IT;
        LDR.N    R1,??DataTable24  ;; 0x40020004
        ADD      R1,R1,#+1024
        B.N      ??DMA_ClearITPendingBit_1
//  669   }
//  670   else
//  671   {
//  672     /* Clear the selected DMA interrupt pending bits */
//  673     DMA1->IFCR = DMA_IT;
??DMA_ClearITPendingBit_0:
        LDR.N    R1,??DataTable24  ;; 0x40020004
??DMA_ClearITPendingBit_1:
        STR      R0,[R1, #+0]
//  674   }
//  675 }
        BX       LR               ;; return
        CFI EndBlock cfiBlock9

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable24:
        DC32     0x40020004

        END
//  676 
//  677 /******************* (C) COPYRIGHT 2008 STMicroelectronics *****END OF FILE****/
//  678 
// 
// 494 bytes in section .text
// 
// 494 bytes of CODE memory
//
//Errors: none
//Warnings: none
