$xml = Invoke-RestMethod https://raw.githubusercontent.com/dfensgmbh/net.sharedop.msp.entityTypes.ManagedOperatingSystem/master/TOSCA-Metadata/TOSCA.meta
$xml.GetType()
$xml
$xml.Definitions
$xml.Definitions.ServiceTemplate
$xml.Definitions.ServiceTemplate.TopologyTemplate.NodeTemplate
$xml.Definitions.ServiceTemplate.TopologyTemplate.NodeTemplate.type
$type = $xml.Definitions.ServiceTemplate.TopologyTemplate.NodeTemplate.type
$xml.Definitions.NodeTypeImplementation
$xml.Definitions.NodeType
$xml.Definitions.NodeType.type -eq $type
$xml.Definitions.NodeType.Interfaces
$xml.Definitions.NodeType.Interfaces.InnerText
$xml.Definitions.NodeType.Interfaces.Interface
$xml.Definitions.NodeType.Interfaces.Interface.name
$xml.Definitions.NodeType.Interfaces.Interface |? name -eq 'biz.dfch.Appclusive.Interfaces.Lifecycle'
$if = $xml.Definitions.NodeType.Interfaces.Interface |? name -eq 'biz.dfch.Appclusive.Interfaces.Lifecycle'
$if
$if.Operation
$if.Operation.Count
$xml.Definitions.NodeTypeImplementation.ImplementationArtifacts.ImplementationArtifact |? operationName -eq 'OnCreated'
foreach($operation in $if.Operation.name) { $operation }
foreach($operation in $if.Operation.name) { $result = $xml.Definitions.NodeTypeImplementation.ImplementationArtifacts.ImplementationArtifact |? operationName -eq $operation; $result }
foreach($operation in $if.Operation.name) { $result = $xml.Definitions.NodeTypeImplementation.ImplementationArtifacts.ImplementationArtifact |? operationName -eq $operation; $result.artifactRef }
$xml.Definitions.ArtifactReferences.ArtifactReference |? id -eq 'cd116073-97b7-45d0-879d-5177de92158d'
($xml.Definitions.ArtifactReferences.ArtifactReference |? id -eq 'cd116073-97b7-45d0-879d-5177de92158d').reference
Invoke-RestMethod 'https://gitlab.msp.sharedop.net/dfensgmbh/net.sharedop.msp.entityTypes.ManagedOperatingSystem/{0}/scripts/OnStarted.bpmn20.xml'
Invoke-RestMethod 'https://github.com/dfensgmbh/net.sharedop.msp.entityTypes.ManagedOperatingSystem/{0}/scripts/OnStarted.bpmn20.xml'
Invoke-RestMethod 'https://raw.githubusercontent.com/dfensgmbh/net.sharedop.msp.entityTypes.ManagedOperatingSystem/master/scripts/OnDecommissioning.bpmn20.xml'
Invoke-RestMethod 'https://raw.githubusercontent.com/dfensgmbh/net.sharedop.msp.entityTypes.ManagedOperatingSystem/master/definitions/biz.dfch.Appclusive.Interfaces.Lifecycle.json'
Invoke-RestMethod 'https://raw.githubusercontent.com/dfensgmbh/net.sharedop.msp.entityTypes.ManagedOperatingSystem/master/definitions/biz.dfch.Appclusive.Interfaces.Lifecycle.json' | ConvertFrom-Json
$fsm = Invoke-RestMethod 'https://raw.githubusercontent.com/dfensgmbh/net.sharedop.msp.entityTypes.ManagedOperatingSystem/master/definitions/biz.dfch.Appclusive.Interfaces.Lifecycle.json'
$fsm.GetType()
