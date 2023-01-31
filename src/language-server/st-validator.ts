import { ValidationAcceptor, ValidationChecks } from 'langium';
import { StAstType, Person } from './generated/ast';
import type { StServices } from './st-module';

/**
 * Register custom validation checks.
 */
export function registerValidationChecks(services: StServices) {
    const registry = services.validation.ValidationRegistry;
    const validator = services.validation.StValidator;
    const checks: ValidationChecks<StAstType> = {
        Person: validator.checkPersonStartsWithCapital
    };
    registry.register(checks, validator);
}

/**
 * Implementation of custom validations.
 */
export class StValidator {

    checkPersonStartsWithCapital(person: Person, accept: ValidationAcceptor): void {
        if (person.name) {
            const firstChar = person.name.substring(0, 1);
            if (firstChar.toUpperCase() !== firstChar) {
                accept('warning', 'Person name should start with a capital.', { node: person, property: 'name' });
            }
        }
    }

}
