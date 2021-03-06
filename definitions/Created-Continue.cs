/**
 * Copyright 2015 d-fens GmbH
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics.Contracts;

namespace net.sharedop.msp.entityTypes.ManagedOperatingSystem
{
    public class CreatedContinue : BaseEntity
    {
        public new CreatedContinue SetDefaults()
        {
            base.SetDefaults();

            Description = "optional-default-description";
            SomeNiftyParameter = 42;

            return this;
        }

        [Required]
        public string Name { get; set; }
        [StringLength(500)]
        [DisplayName("This is a description")]
        public string Description { get; set; }
        public int SomeNiftyParameter { get; set; }
    }
}