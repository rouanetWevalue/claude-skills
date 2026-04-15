# Slack

---

## Opérations disponibles

| Action | Quand l'utiliser |
|---|---|
| `slack_search_public_and_private` | Retrouver un message, une décision, une info dans l'historique |
| `slack_read_channel` | Lire les derniers messages d'un channel |
| `slack_read_thread` | Lire un fil de discussion complet |
| `slack_send_message_draft` | Préparer un message sans l'envoyer (défaut recommandé) |
| `slack_send_message` | Envoyer un message (requiert validation explicite) |
| `slack_search_users` | Trouver l'ID d'un utilisateur pour le mentionner |
| `slack_search_channels` | Trouver le bon channel avant d'envoyer |

---

## Protocole d'envoi

**Toujours passer par un draft** sauf instruction explicite d'envoyer :

1. Rédiger le message
2. Créer un draft (`slack_send_message_draft`)
3. Indiquer à l'utilisateur : "Draft créé dans #channel — confirmez pour envoyer"
4. Envoyer uniquement après validation explicite

---

## Ton par type de message

### Update d'avancement
```
**[Projet / Feature]** — Update [date]

✅ Fait : [ce qui est terminé]
🔄 En cours : [ce qui est en cours]
⏭️ Prochain : [prochaine étape]
⚠️ Blocage : [le cas échéant]
```

### Question / demande d'info
- Court, direct, une seule question si possible
- Mentionner la personne concernée (`@nom`) plutôt que le channel général si c'est adressé à quelqu'un
- Préciser le contexte en 1 ligne max

### Annonce / décision
```
**[DÉCISION / ANNONCE]** [titre court]

[Contexte en 1-2 phrases]

**Ce qui change** : [...]
**À partir de** : [date]
**Questions** : [thread ou contact]
```

---

## Bonnes pratiques

- Toujours vérifier le bon channel avant d'envoyer (`slack_search_channels`)
- Utiliser les **threads** pour les réponses, pas de nouveau message
- Éviter les messages multi-sujets — un message = un sujet
- Pas de `@channel` ou `@here` sans raison urgente
