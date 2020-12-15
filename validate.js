const fs = require('fs')
const assert = require('assert')

const input = process.argv[2] || './ContentBlocker/blockerList.json'

const content = JSON.parse(fs.readFileSync(input, 'utf8'))

const EXCLUSIVE_TRIGGERS = ['domain', 'top-url'].reduce((acc, base) => {
  acc[]
})

const RESOURCE_TYPES = ['image', 'style-sheet', 'script', 'font', 'raw', 'svg-document', 'media', 'popup']

const validateTriggers = triggers => {
  for (const trigger in triggers) {
    const value = triggers[trigger]
    switch(trigger) {
      case 'url-filter-is-case-sensitive': {
        assert(typeof value === 'boolean', `Invalid ${trigger} value. Expected true/false, got ${JSON.stringify(value)}`)
        break;
      }
      case 'if-top-url':
      case 'unless-top-url':
      case 'if-domain':
      case 'unless-domain': {
        break;
      }
      case 'resource-type': {
        assert(RESOURCE_TYPES.includes(value), `Invalid ${trigger} value. Expected one of ${RESOURCE_TYPES.join(', ')}, got ${JSON.stringify(value)}`)
        break;
      }
      default: {
        throw new Error(`Invalid trigger type "${trigger}"`)
      }
    }
    // if (triggerType.startsWith('if-domain'))
    // const exclusivity = EXCLUSIVE_TRIGGERS.find(t => t.includes(triggerType))
    // if(exclusivity && )
  }
}

content.forEach(rule => {
  validateTriggers(rule.trigger)
})

console.log(content)