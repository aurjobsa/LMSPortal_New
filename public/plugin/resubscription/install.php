<?php

/* For licensing terms, see /license.txt */
/**
 * Initialization install.
 *
 * @author Imanol Losada Oriol <imanol.losada@beeznest.com>
 */
require_once __DIR__.'/config.php';

Resubscription::create()->install();
