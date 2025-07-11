//check door => fill water => add detergent => cycle => drain water => spin

module washingMachine(clk,reset,close_door,start,fill,detergent,timeout,drained,spin_timeout,door_lock,motor_on,fill_on,drain_on,done,soapWash,waterWash);

input clk,reset,close_door,start,fill,detergent,timeout,drained,spin_timeout;
output reg door_lock,motor_on,fill_on,drain_on,done,soapWash,waterWash;

//defining the states
parameter check_door = 3'b000;
parameter fill_water=3'b001;
parameter add_detergent=3'b010;
parameter cycle=3'b011;
parameter drain_water=3'b100;
parameter spin=3'b101;

//registers
reg[2:0] currentstate,nextstate;

//block for controlling next state
always@(currentstate or start or close_door or fill or detergent or drained or timeout or spin_timeout)
begin
 case(currentstate)
 
 check_door:
 if(start==1 && close_door==1)
 begin
    nextstate=fill_water;//b001
    motor_on=0;
    fill_on=0;
    drain_on=0;
    door_lock=1;
    soapWash=0;
    waterWash=0;
    done=0;
 end
 else
 begin
    nextstate=currentstate;
    motor_on=0;
    fill_on=0;
    drain_on=0;
    door_lock=0;
    soapWash=0;
    waterWash=0;
    done=0;
 end

 fill_water:
 if(fill==1)
 begin
    if(soapWash==0)
    begin
        nextstate=add_detergent;//b010
    motor_on=0;
    fill_on=0;
    drain_on=0;
    door_lock=1;
    soapWash=1;
    waterWash=0;
    done=0;
    end
    else
    begin
        nextstate=cycle;//b011
    motor_on=0;
    fill_on=0;
    drain_on=0;
    door_lock=1;
    soapWash=1;
    waterWash=1;
    done=0;
    end
 end
 else
begin
    nextstate=currentstate;
    motor_on=0;
    fill_on=1;
    drain_on=0;
    door_lock=1;
    soapWash=0;
    waterWash=0;
    done=0;
end

add_detergent:
if(detergent==1)
begin
       nextstate=cycle;//b011
    motor_on=0;
    fill_on=0;
    drain_on=0;
    door_lock=1;
    soapWash=1;
    waterWash=0;
    done=0;
    end
else
begin
       nextstate=currentstate;
    motor_on=0;
    fill_on=0;
    drain_on=0;
    door_lock=1;
    soapWash=1;
    waterWash=0;
    done=0;
    end

cycle:
if(timeout==1)
begin   nextstate=drain_water;//b100
    motor_on=0;
    fill_on=0;
    drain_on=0;
    door_lock=1;
    done=0;
    end
    else
    begin
           nextstate=currentstate;
    motor_on=1;
    fill_on=0;
    drain_on=0;
    door_lock=1;
    done=0;
    end

drain_water:
if(drained==1)
begin
    if(waterWash==0)
    begin
    nextstate=fill_water;//b001
    motor_on=0;
    fill_on=0;
    drain_on=0;
    door_lock=1;
    soapWash=1;
    done=0;
    end
    else
    begin
    nextstate=spin;//b101
    motor_on=0;
    fill_on=0;
    drain_on=0;
    door_lock=1;
    soapWash=1;
    waterWash=1;
    done=0;
    end
end
else
begin
    nextstate=currentstate;
    motor_on=0;
    fill_on=0;
    drain_on=0;
    door_lock=1;
    soapWash=1;
    waterWash=1;
    done=0;
end

spin:
if(spin_timeout==1)
begin
    nextstate=check_door;//b000
    motor_on=0;
    fill_on=0;
    drain_on=0;
    door_lock=1;
    soapWash=1;
    waterWash=1;
    done=1;
end
else
begin
    nextstate=currentstate;
    motor_on=0;
    fill_on=0;
    drain_on=1;
    door_lock=1;
    soapWash=1;
    waterWash=1;
    done=0;
end

default:
nextstate=check_door;//b000
 endcase
 end
 
 //implementing reset
 always@(posedge clk or negedge reset)
 begin
    if(reset)
    begin
        currentstate<=3'b000;//begins from the start
    end
    else
    begin
        currentstate<=nextstate;
    end
 end

endmodule
