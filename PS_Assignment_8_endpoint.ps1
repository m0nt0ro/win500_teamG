@{

# Version number of the schema used for this document
SchemaVersion = '2.0.0.0'

# ID used to uniquely identify this document
GUID = '501d89b4-9f6d-48e4-8d38-020f8b132563'

# Author of this document
Author = 'Team G'

# Description of the functionality provided by these settings
Description = 'Locked down endpoint only allowing for use of modules created for the assignment. Intended for Service Desk use.'

# Session type defaults to apply for this session configuration. Can be 'RestrictedRemoteServer' (recommended), 'Empty', or 'Default'
SessionType = 'Empty'

# Language mode to apply when applied to a session. Can be 'NoLanguage' (recommended), 'RestrictedLanguage', 'ConstrainedLanguage', or 'FullLanguage'
LanguageMode = 'NoLanguage'

# Modules to import when applied to a session
ModulesToImport = @{'modulename'='7_cmdlets-module'}
VisibleCmdlets = 'start'
}