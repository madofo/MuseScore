//=============================================================================
//  MuseScore
//  Music Composition & Notation
//
//  Copyright (C) 2021 MuseScore BVBA and others
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License version 2.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
//=============================================================================
#ifndef MU_AUDIO_IRPCCONTROLLER_H
#define MU_AUDIO_IRPCCONTROLLER_H

#include <memory>
#include "rpctypes.h"
#include "irpcchannel.h"

namespace mu::audio::rpc {
class IRpcController
{
public:
    virtual ~IRpcController() = default;

    virtual TargetName target() const = 0;

    virtual void init(const IRpcChannelPtr& channel) = 0;

    virtual void handle(const Msg& msg) = 0;
};

using IRpcControllerPtr = std::shared_ptr<IRpcController>;
}

#endif // MU_AUDIO_IRPCCONTROLLER_H
