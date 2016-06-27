<?php

/*
 * This file is part of gpupo/common
 *
 * (c) Gilmar Pupo <g@g1mr.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *
 * For more information, see
 * <http://www.g1mr.com/common/>.
 */
namespace Gpupo\Common\Interfaces;

interface LoggerInterface
{
    public function getLogger();
    public function initLogger($logger);
    public function log($level, $message, array $context = []);
}
