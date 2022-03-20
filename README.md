# GoldefyToken
goldefyToken


<img src="https://goldefy.com/img/logo-comment.png"><Br>

Goldefy Doc
https://docs.goldefy.com/



<a href="https://github.com/siiand/GoldefyToken/blob/main/certik_audit.pdf">GoldeFy CertiK audit DOC.PDF</a><br>
<a href="https://www.certik.com/projects/goldefy">Explore GoldeFy via CertiK</a><br>
<a href="https://github.com/siiand/GoldefyToken/blob/main/zokyo%20audit.pdf">GoldeFy Zokyo audit DOC.PDF</a><Br>



GER-01 | Initial Token Distribution

Recommendation to declare the initial token issuance amount globally and change it so that it can be checked externally

Alternative 1)

Specifying the initial issuance amount in a global variable

GER-02 | Mintable Token

The mint method is centralized in Certic Reports, so there is a transparency problem and hackers can
There is a security advisory that it can be dangerous when the minter role's private key is stolen.

Alternative 1)

Decentralize the minter role to 2-3 with multi-sig, and 2 to 3 signatures when executing actual minting
this
    All should improve the source in the direction that it should proceed, and medium for these parts
Public announcement on or reddit. If minting is absolutely necessary after contract issuance, this method
You have to go ahead and it will take some time.

Alternative 2)

Remove public mint method. It can be processed immediately, but additional minting is not possible after contract issuance
not.

GER-03 | Invisible Implementation Of Contract (antisnipe)

The implementation of the antisnipe contract is not revealed in the bsc chain, only abi is exposed.
West
 The reply is that the contract evaluation is not possible.

Alternative 1)

After requesting the contract source code from antisnipe, it is provided to Certic

GER-04 | Third Party Dependencies


It is pointed out that there is an external dependency, and the vulnerability of errors that can occur in the contract is
to exist
   It is an opinion that it may be.

Alternative 1)

It is a necessary dependency for Goldefy business logic, and the contract is already connected to other contracts.
no problem
I think it would be good to send feedback to Certic that it is being used.

GER-05 | Centralization Risk In GoldefyERC20.sol

The methods to which the Ownable modifier is applied are centralized and the owner's private key is stolen.
This is a security advisory that it can be dangerous if it happens again.

Alternative 1)

_finishMinting, setAntisnipeDisable, pointed out as multi-sig,

setLiquidityRestrictionDisable, setAntisnipeAddress, setLiquidityRestrictionAddress
of methods
        Execution of the sole owner is restricted, so that only two or three signatures are required to proceed.
improve the source in the direction and public on medium or reddit for these
announce. There is an issue of decentralizing the contract owners, and development time is required.
all.

Alternative 2)

Removed all Ownable related code. You can proceed immediately, but the issue raised in GER-02 above
of
As part of the minting function removed, the _finishMinting method issue
There may be no major problems, but the functions related to anti snipe and liquidity restricter are limited.
can be.

GER-06 | Missing Error Messages

It is a recommendation that there is no revert message when checking requires.

Alternative 1)

This can be solved by providing an appropriate message when require revert


Development Team Comments:

Resolved by changing the code in all directions in the suggested direction for the current recommendation of Certic.
cast
 Acknowledged, Partially Resolved, Mitigated, etc.
Acceptance is considered to be resolved. GER-1, 6 can be resolved immediately, and GER-
2, 3, 4, and 5 are issues that require opinions on Haydn’s judgment or maintaining external dependence.
After taking into account the necessary functions and the current situation, modify them all and go, or if time is urgent
Remove all functions that can be pointed out in the audit and issue the most basic ERC-20.
Later, upgrade to another contract or bridge, or if it is deemed necessary
It is possible to explain the function (GER-4, 5) and to proceed with code modification in parallel.
is.

