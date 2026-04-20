# SMs in Verilog
In CS/EE 120B, you learned how to program state machines in C and to use them with a microcontroller. You can make SMs in verilog as well but they can behave a bit different since verilog does not execute code sequentialy like C.

## Basic SM Verilog 
Below is a common way to make an SM in Verilog. You will see some parts of it are similar to what you would expect from an SM in C, such as the enum for the states and the state variable.
```Verilog
module sampleSM (
    input  logic clk,
    input  logic in,
    output logic out
);
    typedef enum logic [3:0]{START, S0, S1, S2, S3} state_t;

    state_t state = START;
    state_t  next_state;

    always_ff @(posedge clk) begin
        state <= next_state;
    end

    always_comb begin
        next_state = state; // Default: stay in current state
        case (state)
            START:next_state = S0;
            S0:next_state = state_t'(in ? S1 : S0);
            S1:next_state = state_t'(in ? S1 : S2);
            S2:next_state = state_t'(in ? S3 : S2);
            S3:next_state = state_t'(in ? S3 : S0);
            default: next_state = START;
        endcase
    end

    always_comb begin
        //START, S1, S3 and default not needed for simulation but needed for synthesis
        case(state)
            START: out = 0;
            S0: out = 0;
            S1: out = 0;
            S2: out = 1;
            S3: out = 1;
            default: out = 0;
        endcase 
    end

endmodule
```
Looking at the SM, you will see there are 3 `always` blocks. The first one is used to update the `state` variable every clock cycle. 

The second one is a combinational block that sets the `next_state` variable. Looking at this, this would look similar to the transition switch statement from your CS/EE120B labs. Because this is a combinational block, it runs every time a value being read from changes. This means in the example above, it runs any time `state` or `in` changes. 

The Third block is combintational again. This is for the actions. Looking at the example you will see the only value read from is `state`, so this will only run every time the state changes.

In order to use this, you would need the clock to be pretty fast in order to capture any state changes from the transition block before the input changes again. This means that you cannot use this SM design for synchronous state machines like the ones you saw in CS/EE120B. You might think that if you just set the `clk` speed in the first block to the period you would want your SM to tick, it would then perform like the synch SMs from before. That would normally be correct, as long as you do not have any mealy actions(actions on the transitions). If you do, you might actidently execute an action that shouldn't have run. For example, if you press a button and then release before the SM should "Tick", it would still execute the transition block but just reset the `next_state` variable since it wasn't saved.

## Synch SM in Verilog
In order to make a synch SM in verilog, we would need to make sure that the transition block only runs on the clock edge. We can do this by changing the `always_comb` into an `always @(posegde clk)`. If we do that, we actually don't really need the first block or the `next_state` variable since we can just save the new state directly in the `state`. This results in the following SM:
```Verilog
module sampleSM (
    input  logic clk,
    input  logic in,
    output logic out
);
    typedef enum logic [3:0]{START, S0, S1, S2, S3} state_t;

    state_t state = START;

    always @(posedge clk) begin
        case (state)
            START:state = S0;
            S0:state = state_t'(in ? S1 : S0);
            S1:state = state_t'(in ? S1 : S2);
            S2:state = state_t'(in ? S3 : S2);
            S3:state = state_t'(in ? S3 : S0);
            default: state = START;
        endcase
    end

    always_comb begin
        //START, S1, S3 and default not needed for simulation but needed for synthesis
        case(state)
            START: out = 0;
            S0: out = 0;
            S1: out = 0;
            S2: out = 1;
            S3: out = 1;
            default: out = 0;
        endcase 
    end

endmodule
```
Looking at this SM, you will notice that the actions block still only executes when the `state` changes. You can change this depending on how you want the your actions to behave. 

## SM for this lab
For this lab, you can design your SM any way you want. Somethings you should keep in mind is that if you do it the first way or just have a really fast clock passed into your SM module, you will probably need a debouncer module for your buttons. [Here](https://nandland.com/debounce-a-switch/) is a link to a Nandland page talking about how to debounce a button.

If you decide to do the synch SM way, you will need a clock divider in order to pass in a clock to the SM module that has the period that you want it to. Look at [top.sv](https://github.com/UCR-CS122A/blinky/blob/main/src/top.sv) from the blinky repo of lab 1 to see a very basic way of making a clock divider. You can also make a clock divider module for a more exact value. This module can just toggle the slower clock after counting a specific amount of positive edges of the original clock.


## Changing SM designs
At the end of the day, you can make any changes you want. You do not need to follow the exact design outline given. If there is a specific functionality that you want to implement but the above SM outlines don't handle it, go ahead and change them.

## PWM Hint
If you recall, PWM outputs were handled in a 2 state SM, however, one of tha labs showed an easy single state SM that was able to handle both 0% and 100% duty cycles(The original 2 state design could not). In verilog, since you can make a block that "Ticks" every rising clock edge, you do not need to actually implement this in the SM format. You can take the logic of the single state SM and put it all in a single `always` block.
