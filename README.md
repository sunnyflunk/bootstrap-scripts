## bootstrap-scripts

This is our work-in-progress repository for bootstrapping the initial Serpent OS images,
which we then use to produce the first self hosting repositories. As explained publicly,
our timescale means that proper development isn't **yet** at full cadence.

Eventually we're looking at simple, configurable shell scripts to automatically build
stage1 + stage2 toolchains, and a corresponding chrootable image which we'll use as a
simple base to flesh out basic requirements, package management, etc.

When package management features are complete, including build tools, one will need to
use a bootstrap image to complete a full bootstrap for a self hosting image.

We plan to make these scripts flexible enough to handle a variety of hardware configurations,
although for initial simplicty (and lack of appropriate hardware) we'll just focus on
x86_64 hardware.
