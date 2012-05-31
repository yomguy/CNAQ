CNAQ : a Matlab acquisition tool for computing transfert function over audio cards


Introduction
===============

CNAQ est un programme de g�n�ration, d'�mission et d'acquisition de signaux
�crit pour Matlab. Il utilise les cartes son int�grant le protocole ASIO pour
d�terminer les fonctions de transfert des syst�mes �lectro-dynamiques.

Fonctionnalit�s principales :

- G�n�rateur de signal (sinus, schip)
- Moniteur temps-r�el
- Mesure de fonctions de transfert


NEWS
=====

 * Back from 2008!!


Installation
===============

Windows ONLY now because of the ASIO technology, sorry.

Uncompress the zip or the tarball in a given directory.


License
===============

This software is licensed as described in the file COPYING, which
you should have received as part of this distribution. The terms
are also available at http://svn.parisson.org/cnaq/CnacqLicense


Usage
=========

Before using CNAQ, you have to read and edit the ASIO config file (config/ASIO.m).
The latency value can to be computed with the get_latency function (tools/get_latency.m).

When configuration is done, simply open CNAQ.m in Matlab and run it (F5)...

Future work
===========

 * link the audio stream to a multi-platform driver

Development
===========

To checkout the last development version, we now use GitHub::

 git clone git://github.com/yomguy/CNAQ.git


Authors
=========

 * Guillaume Pellerin <yomguy@parisson.com>
 * Manuel Melon <melon@cnam.fr>


Aknowledgements
==================

Philippe Herzog, Andrew Gadenko, Manuel Melon.


Contact / Infos
==================

see http://svn.parisson.org/cnaq/ for more details

