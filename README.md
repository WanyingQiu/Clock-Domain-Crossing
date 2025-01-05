# Clock_Domain_Crossing(CDC)
## Problems with CDC
Circuits having asychoronous clocks signals can have issues of metastibility when crossing data in different clock domains.  Metastibility is defined as the unpredictable behaviors of signals due to time violation.
<br />**Setup Time Violation**: The minimum time input flip flop signal needed to be stable before sampled at the clock edge.
<br />**Hold Time Violation**: The time output data must remain stable after clock edge. 
<br />At the end, it can either causes Data loss or Data incorherency.

## Single bit Data Crossing: Slow to Fast Clock Domain:
### Double Flip Flop Synchorizations
It is recommendated to stretch for at least 2 cycles by using double DFF, sampling the input signal with the desitnation clock source. Typically the inputting singal coming from clock domain 1 is registered to get rid of glitches(due to combincational circuit), DFF 2 and 3 controlled by the desitnation clock source are aim to prevent metastability.  
This is not useful for fast to slow clock domain, as input signal needs to be stable for more than one synchorizontion clock period. Also we need to make sure the faster clock is >1.5x frequenct of the slow clock.
![all text](../images/2ff.png)
### Pulse Synchorizations 
Pulse Synchorization works better for slow to fast clock domain, while incoming pulse width has to be greater than the sum of synchorization and first DFF trigger time, with at least twice the synchorization period. 
Due to this, This pulse Synchorizations is limited to frequently changing pulse if it's transferred from fast to slow domain, in such cases some signals might not be sampled by the slow clock domain. 
![all text](../images/edge-2ff.png)

## Single bit Data Crossing: Fast to Slow Clock Domain:
### Toggle Synchorization
Toggle Synchorizations allows data tranmission from fast to slow clock domain.  
Toggle Synchorization also has restriction towards the incoming signals's pulse frequency. It has to be greater/equal to twice the period of the destination clock source.
![all text](../images/toggle_2ff.png)
## Multi bit Data Crossing: Mux Synchoizations
Mux/DMux Synchoizations is a one-way multi-data tranmission mechasism, it requires data to be hold for a certain amount of time until data valid is reveiced by the other clock domain. The AND gate is not used in some cases.
![all text](../images/mux.png)
## Multi bit Data Crossing: HandShake Synchorization
The key of the handshake mechanism is to use the utilize the source clock req signal and ack signal from the destination clock. Both req and ack need to maintain stable and went through a Double FF during sampling time to ensure slow clock domain is able to receive req from the fast clock domain, along with the data needed to be sent during this time.
This mechasim is inefficient as each data transistance needs multiple clock period to communicate.  It is more frequently to use in small amount of multi-bit data transaction.
![all text](../images/handshake.png)
## Multi bit Data Crossing: FIFO Synchorizations 
For multiple data transferring, a FIFO is the more common way for data communication between clock domains. 
![all text](../images/asyn_fifo.png)
### Gray Encoder/Decoder 
Before transferring, data are converted into gray code.  The Gray code counter ensures 1-bit transition occurs whiles the other remains the same for each data transferring.  This is a protection to setup or hold time violation: at most one bit is being metastable at the source/destination clock edge, and to prevent FIFO reading when it's empty, FIFO writing when it is full. 
### FIFO(2Port RAM)
For a FIFO with 2^n entry, we need n+1 depth to represnt the single address bit and gray code.
```Verilog
localparam FIFO_DEPTH = 1 << ADDR_WIDTH;
```



