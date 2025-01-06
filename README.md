# Clock_Domain_Crossing(CDC)
## Problems with CDC
Circuits having asychoronous clocks signals can have issues of metastibility when crossing data in different clock domains.  Metastibility is defined as the unpredictable behaviors of signals due to time violation.
<br />**Setup Time Violation**: The minimum time input flip flop signal needed to be stable before sampled at the clock edge.
<br />**Hold Time Violation**: The time output data must remain stable after clock edge. 
<br />At the end, it can either causes Data loss or Data incorherency.

## Single bit Data Crossing: Slow to Fast Clock Domain:
### Double Flip Flop Synchorizations
It is recommendated to stretch for at least 2 cycles by using double DFF, sampling the input signal with the desitnation clock source. The input signal from Clock Domain 1 (source) is typically registered first using a D flip-flop to eliminate any glitches caused by combinational circuits. This ensures the signal is clean before synchronization. DFF 2 and 3 controlled by the desitnation clock source are aim to prevent metastability.  
This is not practically useful for fast to slow clock domain, as the input signal needs to remain stable for more than one synchronization clock period. If not, the destination domain may miss changes in the signal. The faster clock must typically be at least 1.5x the frequency of the slower clock to ensure proper synchronization.
![2ff](https://github.com/user-attachments/assets/6d5ccdfd-850d-4909-8b98-5cff8583ca3f)

### Pulse Synchorizations 
Pulse synchronization is generally more effective when transferring **pulse** signals from a slow clock domain to a fast clock domain with the following constraints:
<br />The pulse width in the source clock domain must exceed both the synchronization delay caused by metastability resolution and the time required for the first flip-flop (DFF) in the destination domain to register the signal.
<br />The pulse must remain stable for at least twice the synchronization period to ensure reliable sampling by the destination clock domain.
A fast clock domain can typically sample every pulse, provided the above constraints are met, making this approach well-suited for slow-to-fast clock domain transfers.  But this might not work well with fast to slow domain with the restrictions mentioned above.  
![edge-2ff](https://github.com/user-attachments/assets/57e68ca3-dd66-418b-b22b-be02ee056533)

## Single bit Data Crossing: Fast to Slow Clock Domain:
### Toggle Synchorization
Toggle synchronization is a technique used to reliably transfer pulse signals from a fast clock domain to a slow clock domain. 

Toggle Synchorization also has restriction towards the incoming signals's pulse frequency. The incoming pulse frequency must be greater than or equal to twice the period of the destination clock.
![toggle_2ff](https://github.com/user-attachments/assets/31fcb19f-ae87-4027-b611-bb786c2b4128)

## Multi bit Data Crossing: Mux Synchoizations
Mux/DMux Synchoizations is a one-way multi-data tranmission mechasism, it requires data to be hold for a certain amount of time until data valid is reveiced by the other clock domain. The AND gate is not used in some cases.  Also there is no handshake mechasim to check whether data tranmistted is correct or not.
MUX/DMUX Synchronization is a one-way, multi-data transmission mechanism where data is held for a specific duration until the receiving clock domain asserts data-valid. Unlike more robust protocols, this method lacks a handshake mechanism to verify the correctness of the transmitted data, which can lead to potential synchronization issues if proper timing constraints are not met.

While logic gates like AND gates are commonly used in synchronization circuits, there are cases where their usage is omitted, depending on the specific design requirements. 
![mux](https://github.com/user-attachments/assets/12cc1df6-ce22-49ba-88b7-4727a28ea621)

## Multi bit Data Crossing: HandShake Synchorization
The handshake mechanism is a bidirectional communication protocol used for synchronizing data transfer between clock domains. It relies on req from source domain and ack signal from destination domain.

The handshake mechanism is inherently slow because it requires multiple clock cycles(time it takes for req signal to propogate to destination and ack signal sent back to source clock domain) to complete a single data transfer. This is especially true when there is a significant frequency difference between the source and destination clock domains.  Due to its inefficiency, this mechanism is typically reserved for small amounts of multi-bit data transfer, where reliability and synchronization are more critical than throughput.

![handshake](https://github.com/user-attachments/assets/cb2c4279-12e9-40f5-acdf-72c7e495a812)

## Multi bit Data Crossing: FIFO Synchorizations 
For throughput-intensive multiple data transferring, a FIFO is the more common way for data communication between clock domains. 
![asyn_fifo](https://github.com/user-attachments/assets/9d79e275-8d98-4fe9-84e7-d1853378b5ef)

### Gray Encoder/Decoder 
As the data is converted into Gray code before being transferred across the clock domain, only one bit of the data changes between consecutive values. This reduces the risk of synchronization issues, ensuring that only one bit might be metastable at any given time.  Additionally, it safeguards against issues like empty FIFO reads and full FIFO writes, making it an important technique in handling asynchronous data transfer with greater integrity.
### FIFO(2Port RAM)
For a FIFO with 2^n entry, we need n+1 depth to represnt the single address bit and gray code.
```Verilog
localparam FIFO_DEPTH = 1 << ADDR_WIDTH;
```



