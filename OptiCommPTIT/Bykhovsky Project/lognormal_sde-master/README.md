# lognormal_sde
This is supplementary downloadable material, provided by the authors of the paper:

D. Bykhovsky, "Channel Simulator for Weak-Turbulence Free-Space Optical Communications," Appl. Opt. 54, 9055-9059 (2015), http://dx.doi.org/10.1364/AO.54.009055.

The goal of this work is to generate lognormal distributed values with approximately exponential auto-covariance function and is based on a solution of first order stochastic differential equation (SDE). The provided code produces an example of such values, including probability density function (PDF) and auto-correlation function (ACF).
This code includes two Matlab files:

a) logn_sde.m – this file runs without any dependencies.

b) logn_sde2.m – this time the same code uses the numerical solution provided by “A Matlab Toolbox for the Numerical Solution of Stochastic Differential Equations (SDEs)” from https://github.com/horchler/SDETools.

This code includes one Mathematica file (v. 10+) with similar functionality.

THIS SOFTWARE IS PROVIDED BY AUTHORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

