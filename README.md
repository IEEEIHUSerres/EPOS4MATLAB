# EPOS 4 (for) MATLAB
Commanding Maxon EPOS 4 Motor Controller(s) from MATLAB

# Requirements
* A computer with Windows OS (Tested on Windows 10 Pro 1909)
* EPOS Studio (Tested with EPOS Studio 2.4)
* EPOS 4 Motor Controller (Tested with integrated motor - Exoskeleton Joint Actuator)
* MATLAB (Tested with R2019b)
* C++ Compiler (Tested with Microsoft Visual C++ 2019 (C) - Visual Studio 2019)

# How to use it
* Clone the repository `git clone git@github.com:IordanisKostelidis/EPOS4MATLAB.git`
* Download and install the EPOS Studio - [Download Now](https://www.maxongroup.com/medias/sys_master/root/8837358125086/EPOS-2-4-IDX-Setup.zip)
* From `C:\Program Files (x86)\maxon motor ag\EPOS IDX\EPOS4`, find and copy the following files to `./EPOS4MATLAB/Epos4Windows`
    * `Definitions.h`
    * `EposCmd.dll`
    * `EposCmd.lib`
    * `EposCmd64.dll`
    * `EposCmd64.lib`
    * `vxlapi.dll`
    * `vxlapi64.dll`
* Start the MATLAB
* Open the `./EPOS4MATLAB` using MATLAB command window
* Run the following commands from MATLAB command window
    ```
    Clean
    Make
    ```
* Connect your EPOS 4 Motor Controller with USB
* Run the demo with the following command
    ```
    DemoEpos
    ```

# ACKNOWLEDGMENTS
* This library is original written by Eugenio Yime Rodriguez <Universidad Tecnologica de Bolivar> for EPOS 2 Motor Controllers
* This is a modified version by Iordanis Kostelidis <HERMES Team> for EPOS 4 Motor Controllers

# LICENSE
Copyright (c) 2015, Eugenio
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution
* Neither the name of Universidad Tecnologica de Bolivar nor the names of its
  contributors may be used to endorse or promote products derived from this
  software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
