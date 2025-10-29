// srv/service.js
const cds = require('@sap/cds')

/**
 * Serviço CAP (classe) com init() e handlers de negócio
 * - Valida startAt < endAt (CREATE/UPDATE)
 * - Impede overlapping no mesmo room (CREATE/UPDATE)
 * - Calcula durationMinutes automaticamente (CREATE/UPDATE)
 * - Define status default em CREATE (se ausente)
 * - Pequenos logs após CREATE
 */
class CatalogService extends cds.ApplicationService {
  async init() {
    const { Reservations } = this.entities

    // -------- Helpers --------
    const getUUID = (req) =>
      req.data?.ID || req.params?.[0]?.ID || null

    const normalizeRoomID = (roomField) => {
      if (!roomField) return null
      if (typeof roomField === 'string') return roomField            // já é UUID
      if (roomField.ID) return roomField.ID                          // association object {ID:...}
      if (roomField._id) return roomField._id                        // raros casos
      return roomField
    }

    const toDateOrNull = (v) => {
      if (!v) return null
      const d = new Date(v)
      return isNaN(d.getTime()) ? null : d
    }

    const overlapWhere = (roomId, startAt, endAt, exceptId) => {
      // Intersecção de intervalos: (Astart < Bend) AND (Aend > Bstart)
      // E ignora CANCELLED
      const cqn = [
        { ref: ['room_ID'] }, '=', { val: roomId },
        'and', { ref: ['status'] }, '!=', { val: 'CANCELLED' },
        'and', '(', { val: startAt }, '<', { ref: ['endAt'] },
              'and', { val: endAt }, '>', { ref: ['startAt'] }, ')'
      ]
      if (exceptId) {
        cqn.push('and', { ref: ['ID'] }, '!=', { val: exceptId })
      }
      return cqn
    }

    // -------- BEFORE: validações e cálculo --------
    this.before(['CREATE', 'UPDATE'], 'Reservations', async req => {
      // Normalizações
      const id       = getUUID(req)
      const roomId   = normalizeRoomID(req.data.room_ID || req.data.room)
      const start    = toDateOrNull(req.data.startAt)
      const end      = toDateOrNull(req.data.endAt)

      // Campos obrigatórios mínimos
      if (!roomId)  return req.reject(400, 'A sala (room_ID) é obrigatória.')
      if (!start)   return req.reject(400, 'startAt inválido ou ausente.')
      if (!end)     return req.reject(400, 'endAt inválido ou ausente.')

      // start < end
      if (start >= end) {
        return req.reject(400, 'Hora de início (startAt) deve ser menor que a hora de fim (endAt).')
      }

      // Overlapping no mesmo room (ignora CANCELLED e ignora a própria reserva em UPDATE)
      const clash = await SELECT.one.from(Reservations).where(overlapWhere(roomId, start, end, id))
      if (clash) {
        return req.reject(409, 'Já existe uma reserva neste intervalo para a mesma sala.')
      }

      // durationMinutes calculado
      req.data.durationMinutes = Math.round((end - start) / 60000)

      // status por omissão em CREATE (só se não vier definido)
      if (req.event === 'CREATE' && (req.data.status == null || req.data.status === '')) {
        req.data.status = 'CONFIRMED'
      }

      // Garantes que o association fica no campo certo (room_ID)
      req.data.room_ID = roomId
    })

    // -------- AFTER: logs / efeitos colaterais --------
    this.after('CREATE', 'Reservations', (data, req) => {
      // Logs simples (troca por chamada de e-mail/Teams se quiseres)
      cds.log('reservations').info(
        `Reserva criada ${data.ID} | Sala=${data.room_ID} | ${data.startAt} → ${data.endAt} | status=${data.status}`
      )
    })

    // (Opcional) Soft delete: intercepta DELETE e transforma em CANCELLED
    // Descomenta se quiseres esta política
    /*
    this.before('DELETE', 'Reservations', async req => {
      const id = getUUID(req)
      if (!id) return req.reject(400, 'ID da reserva é obrigatório para cancelar.')
      await UPDATE(Reservations).set({ status: 'CANCELLED' }).where({ ID: id })
      req.reply({ cancelled: true })   // devolve uma resposta custom
    })
    */

    return super.init()
  }
}

module.exports = { CatalogService }
